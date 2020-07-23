-----------------------------------------------------------------------
--  search-indexers-databases -- Search engine indexer
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

with Search.Fields;
with Search.Tokens;
with Search.Tokenizers;
with Search.Documents;
with Search.Analyzers;
with ADO.Sessions;
private with Search.Positions;
private with Search.Tokens.Factories.Default;
private with Search.Models;
private with Search.Tokens.Compare;
private with Ada.Containers.Hashed_Maps;
private with Generic_Indefinite_B_Tree;
private with Persistent.Memory_Pools.Streams.Generic_External_B_Tree;
private with Persistent.Blocking_Files.Transactional.Dump;
private with Persistent.Memory_Pools.Dump;
package Search.Indexers.Databases is

   type Indexer_Type is limited new Search.Indexers.Indexer_Type with private;

   --  Initialize the indexer.
   procedure Initialize (Indexer : in out Indexer_Type;
                         Session : in out ADO.Sessions.Master_Session;
                         Ident   : in ADO.Identifier);

   --  Add the field in the index.  The field content is not tokenized.
   procedure Add_Field (Indexer  : in out Indexer_Type;
                        Document : in out Search.Documents.Document_Type'Class;
                        Field    : in Search.Fields.Field_Type);

   --  Add the document in the index by storing and indexing all indexable fields.
   procedure Add_Document (Indexer   : in out Indexer_Type;
                           Document  : in out Search.Documents.Document_Type'Class;
                           Analyzer  : in out Search.Analyzers.Analyzer_Type'Class;
                           Tokenizer : in out Search.Tokenizers.Tokenizer_Type'Class);

   overriding
   procedure Add_Field (Indexer   : in out Indexer_Type;
                        Document  : in out Search.Documents.Document_Type'Class;
                        Field     : in Search.Fields.Field_Type;
                        Analyzer  : in out Search.Analyzers.Analyzer_Type'Class;
                        Tokenizer : in out Search.Tokenizers.Tokenizer_Type'Class);

   procedure Add_Token (Indexer  : in out Indexer_Type;
                        Document : in out Search.Documents.Document_Type'Class;
                        Field    : in Search.Fields.Field_Type;
                        Token    : in String);

private

   use ADO;

   type Position_Access is access all Search.Positions.Position_Type;

   package Persistent_Fields is
      new Persistent.Memory_Pools.Streams.Generic_External_B_Tree
     (String, Search.Positions.Position_Type,
      String'Input, Search.Positions.Read,
      String'Output, Search.Positions.Write);

   package Field_Maps is
      new Ada.Containers.Hashed_Maps (Key_Type        => Search.Fields.Field_Type,
                                      Element_Type    => ADO.Identifier,
                                      Hash            => Search.Fields.Hash,
                                      Equivalent_Keys => Search.Fields."=");

   package Position_Maps is
      new Ada.Containers.Hashed_Maps (Key_Type        => Search.Tokens.Token_Type,
                                      Element_Type    => Position_Access,
                                      Hash            => Search.Tokens.Compare.Hash,
                                      Equivalent_Keys => Search.Tokens.Compare."=");

   protected type Field_Map is

      procedure Insert (Field : in Search.Fields.Field_Type;
                        Id : in ADO.Identifier);

      function Find (Field : in Search.Fields.Field_Type) return ADO.Identifier;

   private
      Fields : Field_Maps.Map;
   end Field_Map;

   package Token_Maps is
      new Ada.Containers.Hashed_Maps (Key_Type        => Search.Tokens.Token_Type,
                                      Element_Type    => ADO.Identifier,
                                      Hash            => Search.Tokens.Compare.Hash,
                                      Equivalent_Keys => Search.Tokens.Compare."=");

   protected type Token_Map is

      procedure Insert (Token : in Search.Tokens.Token_Type;
                        Id    : in ADO.Identifier);

      function Find (Token : in Search.Tokens.Token_Type) return ADO.Identifier;

      procedure Create (Value : in String;
                        Token : out Search.Tokens.Token_Type);

   private
      Tokens  : Token_Maps.Map;
      Factory : Search.Tokens.Factories.Default.Token_Factory;
   end Token_Map;

   type Indexer_Type is limited new Search.Indexers.Indexer_Type with record
      DB        : aliased Persistent.Blocking_Files.Transactional.Persistent_Transactional_Array;
      Session   : ADO.Sessions.Master_Session;
      Index     : Search.Models.Index_Ref;
      Fields    : Field_Map;
      Tokens    : Token_Map;
      Positions : Position_Maps.Map;
      Document  : Search.Models.Document_Ref;
      Position  : Natural := 0;
   end record;

end Search.Indexers.Databases;
