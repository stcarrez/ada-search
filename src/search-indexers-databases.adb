-----------------------------------------------------------------------
--  search-indexers -- Search engine indexer
--  Copyright (C) 2020 Stephane Carrez
--  Written by Stephane Carrez (Stephane.Carrez@gmail.com)
--
--  Licensed under the Apache License, Version 2.0 (the "License");
--  you may not use this file except in compliance with the License.
--  You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
--  Unless required by applicable law or agreed to in writing, software
--  distributed under the License is distributed on an "AS IS" BASIS,
--  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--  See the License for the specific language governing permissions and
--  limitations under the License.
-----------------------------------------------------------------------

package body Search.Indexers.Databases is

   protected body Field_Map is

      procedure Insert (Field : in Search.Fields.Field_Type;
                        Id : in ADO.Identifier) is
      begin
         Fields.Insert (Field, Id);
      end Insert;

      function Find (Field : in Search.Fields.Field_Type) return ADO.Identifier is
         Pos : constant Field_Maps.Cursor := Fields.Find (Field);
      begin
         if Field_Maps.Has_Element (Pos) then
            return Field_Maps.Element (Pos);
         else
            return ADO.NO_IDENTIFIER;
         end if;
      end Find;

   end Field_Map;

   protected body Token_Map is

      procedure Insert (Token : in Search.Tokens.Token_Type;
                        Id    : in ADO.Identifier) is
      begin
         Tokens.Insert (Token, Id);
      end Insert;

      function Find (Token : in Search.Tokens.Token_Type) return ADO.Identifier is
         Pos : constant Token_Maps.Cursor := Tokens.Find (Token);
      begin
         if Token_Maps.Has_Element (Pos) then
            return Token_Maps.Element (Pos);
         else
            return ADO.NO_IDENTIFIER;
         end if;
      end Find;

      procedure Create (Value : in String;
                        Token : out Search.Tokens.Token_Type) is
      begin
         Factory.Create (Value, Token);
      end Create;

   end Token_Map;

   --  Initialize the indexer.
   procedure Initialize (Indexer : in out Indexer_Type;
                         Session : in out ADO.Sessions.Master_Session;
                         Ident   : in ADO.Identifier) is
   begin
      Indexer.Session := Session;
      if Ident /= ADO.NO_IDENTIFIER then
         Indexer.Index.Load (Session, Ident);
      else
         Indexer.Index.Save (Session);
      end if;
      Persistent.Blocking_Files.Transactional.Open
        (Container => Indexer.DB,
         Name      => "test_benchmark.db",
         Mode      => Persistent.Blocking_Files.Create_Mode,
         Map_Size  => Persistent.Blocking_Files.Transactional.Get_Map_Size (100),
         Hash_Size => 1024);

   end Initialize;

   procedure Save (Indexer : in out Indexer_Type;
                   Field   : in Search.Fields.Field_Type) is
      Field_Id : ADO.Identifier := Indexer.Fields.Find (Field);
      Pos      : Position_Maps.Cursor := Indexer.Positions.First;
      Pool     : aliased Persistent.Memory_Pools.Persistent_Pool (Indexer.DB'Access);
      Tree     : Persistent_Fields.B_Tree (Pool'Access);
   begin
      if Field_Id = ADO.NO_IDENTIFIER then
         declare
            Db_Field : Search.Models.Field_Ref;
         begin
            Db_Field.Set_Document (Indexer.Document);
            Db_Field.Set_Name (Search.Fields.Get_Name (Field));
            Db_Field.Set_Value (Search.Fields.Get_Value (Field));
            Db_Field.Save (Indexer.Session);
            Field_Id := Db_Field.Get_Id;
            Indexer.Fields.Insert (Field, Field_Id);
         end;
      end if;

      while Position_Maps.Has_Element (Pos) loop
         declare
            Token     : Search.Tokens.Token_Type := Position_Maps.Key (Pos);
            Positions : constant Position_Access := Position_Maps.Element (Pos);
            Db_Seq    : Search.Models.Sequence_Ref;
            Token_Id  : ADO.Identifier;

            procedure Set_Positions (Data : in Ada.Streams.Stream_Element_Array) is
            begin
               Db_Seq.Set_Positions (ADO.Create_Blob (Data));
            end Set_Positions;

         begin
            Token_Id := Indexer.Tokens.Find (Token);
            if Token_Id = ADO.NO_IDENTIFIER then
               declare
                  Db_Token : Search.Models.Token_Ref;
               begin
                  Db_Token.Set_Index (Indexer.Index);
                  Db_Token.Set_Name (Token.Get_Value);
                  --  Db_Token.Save (Indexer.Session);
                  Token_Id := Db_Token.Get_Id;
                  Indexer.Tokens.Insert (Token, Token_Id);
               end;
            end if;

            Search.Positions.Pack (Positions.all, Set_Positions'Access);
            Db_Seq.Set_Token (Token_Id);
            Db_Seq.Set_Field (Field_Id);
            --  Db_Seq.Save (Indexer.Session);
            Persistent_Fields.Add (Tree, Token.Get_Value, Positions.all);
         end;
         Position_Maps.Next (Pos);
      end loop;
      Persistent.Memory_Pools.Commit (Pool);
   end Save;

   procedure Add_Document (Indexer   : in out Indexer_Type;
                           Document  : in out Search.Documents.Document_Type'Class;
                           Analyzer  : in out Search.Analyzers.Analyzer_Type'Class;
                           Tokenizer : in out Search.Tokenizers.Tokenizer_Type'Class) is
   begin
      Indexer.Position := 0;
      Indexer.Document.Set_Index (Indexer.Index);
      Indexer.Document.Save (Indexer.Session);
      Search.Indexers.Indexer_Type (Indexer).Add_Document (Document, Analyzer, Tokenizer);
   end Add_Document;

   procedure Add_Field (Indexer   : in out Indexer_Type;
                        Document  : in out Search.Documents.Document_Type'Class;
                        Field     : in Search.Fields.Field_Type;
                        Analyzer  : in out Search.Analyzers.Analyzer_Type'Class;
                        Tokenizer : in out Search.Tokenizers.Tokenizer_Type'Class) is
   begin
      Search.Indexers.Indexer_Type (Indexer).Add_Field (Document, Field, Analyzer, Tokenizer);
      Save (Indexer, Field);
   end Add_Field;

   procedure Add_Token (Indexer  : in out Indexer_Type;
                        Document : in out Search.Documents.Document_Type'Class;
                        Field    : in Search.Fields.Field_Type;
                        Token    : in String) is
      Tok      : Search.Tokens.Token_Type;
      Pos      : Position_Maps.Cursor;
   begin
      Indexer.Tokens.Create (Token, Tok);

      Indexer.Position := Indexer.Position + 1;

      Pos := Indexer.Positions.Find (Tok);
      if not Position_Maps.Has_Element (Pos) then
         declare
            Positions : constant Position_Access := new Search.Positions.Position_Type;
         begin
            Search.Positions.Add (Positions.all, Indexer.Position);
            Indexer.Positions.Insert (Tok, Positions);
         end;
      else
         declare
            Positions : constant Position_Access := Position_Maps.Element (Pos);
         begin
            Search.Positions.Add (Positions.all, Indexer.Position);
         end;
      end if;
   end Add_Token;

   --  ------------------------------
   --  Add the field in the index.  The field content is not tokenized.
   --  ------------------------------
   procedure Add_Field (Indexer  : in out Indexer_Type;
                        Document : in out Search.Documents.Document_Type'Class;
                        Field    : in Search.Fields.Field_Type) is
   begin
      null;
   end Add_Field;

end Search.Indexers.Databases;
