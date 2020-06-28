-----------------------------------------------------------------------
--  search-lexers -- Search engine lexers
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

package body Search.Tokenizers is

   use Ada.Streams;

   procedure Fill (Lexer  : in out Tokenizer_Type;
                   Stream : in out Util.Streams.Input_Stream'Class) is
      Remain : constant Lexer_Offset := Lexer.Last - Lexer.Pos;
      Pos    : Lexer_Offset := Lexer.Buffer'First;
   begin
      if Remain > 0 then
         Lexer.Buffer (Lexer.Buffer'First .. Lexer.Buffer'First + Remain - 1)
           := Lexer.Buffer (Lexer.Pos .. Lexer.Last);
         Pos := Lexer.Buffer'First + Remain;
      end if;
      Stream.Read (Lexer.Buffer (Pos .. Lexer.Buffer'Last), Lexer.Last);
      Lexer.Pos := Lexer.Buffer'First;
   end Fill;

   procedure Skip_Spaces (Lexer  : in out Tokenizer_Type;
                          Stream : in out Util.Streams.Input_Stream'Class) is
      Pos : Lexer_Offset := Lexer.Pos;
   begin
      loop
         if Pos >= Lexer.Last then
            Lexer.Pos := Pos;
            Lexer.Fill (Stream);
            Pos := Lexer.Pos;
            exit when Pos >= Lexer.Last;
         end if;
         exit when Character'Val (Lexer.Buffer (Pos)) /= ' ';
         Pos := Pos + 1;
      end loop;
      Lexer.Pos := Pos;
   end Skip_Spaces;

   procedure Read_Token (Lexer  : in out Tokenizer_Type;
                         Stream : in out Util.Streams.Input_Stream'Class) is
      Pos : Lexer_Offset := Lexer.Pos;
      C   : Character;
   begin
      loop
         if Pos >= Lexer.Last then
            Lexer.Pos := Pos;
            Lexer.Fill (Stream);
            Pos := Lexer.Pos;
            exit when Pos >= Lexer.Last;
         end if;

         C := Character'Val (Lexer.Buffer (Pos));
         exit when C = ' ';
         Util.Strings.Builders.Append (Lexer.Text, C);
         Pos := Pos + 1;
      end loop;
      Lexer.Pos := Pos;
   end Read_Token;

   procedure Parse (Lexer    : in out Tokenizer_Type;
                    Stream   : in out Util.Streams.Input_Stream'Class;
                    Consumer : in out Consumer_Type'Class) is

      procedure Process (Content : in String) is
      begin
         Consumer.Push_Token (Content);
      end Process;

      procedure Process_Token is
         new Util.Strings.Builders.Get (Process);

      Pos : Lexer_Offset;
   begin
      loop
         Lexer.Skip_Spaces (Stream);
         Pos := Lexer.Pos;
         exit when Pos >= Lexer.Last;

         Lexer.Read_Token (Stream);
         Process_Token (Lexer.Text);
      end loop;
   end Parse;

end Search.Tokenizers;
