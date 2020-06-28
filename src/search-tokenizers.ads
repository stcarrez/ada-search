-----------------------------------------------------------------------
--  search-tokenizers -- Search engine tokenizers
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
with Ada.Finalization;
with Util.Streams;
private with Util.Strings.Builders;
private with Ada.Streams;

--  == Tokenizers ==
--  Tokenizers read the input stream to identify the token string and give them
--  to the analyzer.
package Search.Tokenizers is

   type Consumer_Type is limited Interface;

   procedure Push_Token (Consumer : in out Consumer_Type;
                         Token    : in String) is abstract;

   type Tokenizer_Type is limited new Ada.Finalization.Limited_Controlled with private;

   procedure Parse (Lexer    : in out Tokenizer_Type;
                    Stream   : in out Util.Streams.Input_Stream'Class;
                    Consumer : in out Consumer_Type'Class);

   procedure Fill (Lexer  : in out Tokenizer_Type;
                   Stream : in out Util.Streams.Input_Stream'Class);

   procedure Skip_Spaces (Lexer  : in out Tokenizer_Type;
                          Stream : in out Util.Streams.Input_Stream'Class);

   procedure Read_Token (Lexer  : in out Tokenizer_Type;
                         Stream : in out Util.Streams.Input_Stream'Class);

private

   subtype Lexer_Offset is Ada.Streams.Stream_Element_Offset;

   type Tokenizer_Type is limited new Ada.Finalization.Limited_Controlled with record
      Pos    : Lexer_Offset := 0;
      Last   : Lexer_Offset := 0;
      Buffer : Ada.Streams.Stream_Element_Array (1 .. 1024);
      Text   : Util.Strings.Builders.Builder (128);
   end record;

end Search.Tokenizers;
