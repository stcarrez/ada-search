-----------------------------------------------------------------------
--  search-tokens-factories -- Factory definition to create tokens
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

package body Search.Tokens.Factories.Default is

   overriding
   procedure Create (Factory : in out Token_Factory;
                     Value   : in String;
                     Token   : out Token_Type) is
      R : Token_Refs.Ref;
      Item : Search.Tokens.Sets.Cursor;
   begin
      R := Token_Refs.Create (new Token_Content_Type '(Util.Refs.Ref_Entity with
                                                         Length => Value'Length,
                                                       Value => Value));
      Token := Token_Type '(R with others => <>);
      Item := Factory.Tokens.Find (Token);
      if Search.Tokens.Sets.Has_Element (Item) then
         Token := Search.Tokens.Sets.Element (Item);
      else
         Factory.Tokens.Insert (Token);
      end if;
   end Create;

end Search.Tokens.Factories.Default;
