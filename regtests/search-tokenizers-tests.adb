-----------------------------------------------------------------------
--  search-tokenizers-tests -- Tests for tokenizers
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

with Util.Test_Caller;
with Search.Fields;
with Search.Tokens.Factories.Default;
package body Search.Tokenizers.Tests is

   package Caller is new Util.Test_Caller (Test, "Search.Tokenizers");

   procedure Add_Tests (Suite : in Util.Tests.Access_Test_Suite) is
   begin
      Caller.Add_Test (Suite, "Test Search.Tokenizers.Factories",
                       Test_Simple_Tokenizer'Access);
   end Add_Tests;

   overriding
   procedure Push_Token (Filter   : in out Test;
                         Token    : in String;
                         Consumer : not null
                           access procedure (Token : in String)) is
   begin
      Filter.Set.Insert (Token);
      Consumer (Token);
   end Push_Token;

   procedure Test_Simple_Tokenizer (T : in out Test) is
      Field   : Search.Fields.Field_Type;
      Analyze : Search.Tokenizers.Tokenizer_Type;

      procedure Consumer (Token : in String) is
      begin
         T.Assert (Token'Length > 0, "Invalid token");
      end Consumer;

      procedure Consume (S : in out Util.Streams.Input_Stream'Class) is
      begin
         Analyze.Parse (S, T, Consumer'Access);
      end Consume;

   begin
      Field := Search.Fields.Create ("title", "word1 word2 word3", Search.Fields.F_CONTENT);
      Search.Fields.Stream (Field, Consume'Access);

      T.Assert (T.Set.Contains ("word1"), "word1 is missing");
      T.Assert (T.Set.Contains ("word2"), "word2 is missing");
      T.Assert (T.Set.Contains ("word3"), "word3 is missing");

   end Test_Simple_Tokenizer;

end Search.Tokenizers.Tests;
