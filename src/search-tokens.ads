-----------------------------------------------------------------------
--  search-tokens -- Search engine token representation
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

--  == Token ==
--  The token represents a string that is indexed.  Once created the token
--  cannot be modified.
private with Util.Refs;
package Search.Tokens is

   type Token_Type is tagged private;

   function Get_Value (Token : in Token_Type) return String;

private

   type Token_Content_Type (Length : Natural) is limited new Util.Refs.Ref_Entity
     with record
      Value : String (1 .. Length);
   end record;
   type Token_Content_Access is access all Token_Content_Type'Class;

   package Token_Refs is
     new Util.Refs.Indefinite_References (Element_Type   => Token_Content_Type'Class,
                                          Element_Access => Token_Content_Access);

   type Token_Type is new Token_Refs.Ref with null record;

end Search.Tokens;
