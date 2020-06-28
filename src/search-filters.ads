-----------------------------------------------------------------------
--  search-filters -- Search engine filters
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
with Search.Tokenizers;

--  == Filters ==
--  Filters are used to make some text transformation on token strings produced by the lexer.
--  They are chained together and the end of the chain gives the token string to the tokenizer.
--  A filter can transform the string in lower case, another can compute the stem of the word
--  and only return stems, another may filter and ignore some words.
--
--  The `Filter_Chain` holds the chain of filters and each filter is added by using the
--  `Add_Filter` procedure.
package Search.Filters is

   type Filter_Type is abstract limited new Ada.Finalization.Limited_Controlled
     and Search.Tokenizers.Consumer_Type With private;
   type Filter_Type_Access is access all Filter_Type'Class;

   overriding
   procedure Push_Token (Chain  : in out Filter_Type;
                         Token  : in String);

   type Filter_Chain is new Filter_Type with private;

   procedure Add_Filter (Chain  : in out Filter_Chain;
                         Filter : in Filter_Type_Access);

private

   type Filter_Type is abstract limited new Ada.Finalization.Limited_Controlled
     and Search.Tokenizers.Consumer_Type With record
      Next     : Filter_Type_Access;
   end record;

   type Filter_Chain is new Filter_Type with null record;

end Search.Filters;
