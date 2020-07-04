-----------------------------------------------------------------------
--  search-fields -- Document fields
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

package body Search.Fields is

   --  ------------------------------
   --  Get the field name.
   --  ------------------------------
   function Get_Name (Field : in Field_Type) return String is
   begin
      return To_String (Field.Name);
   end Get_Name;

   --  ------------------------------
   --  Returns True if this field is indexable.
   --  ------------------------------
   function Is_Indexable (Field : in Field_Type) return Boolean is
   begin
      return Field.Kind = F_TOKEN;
   end Is_Indexable;

   --  ------------------------------
   --  Returns True if this field is composed of multiple tokens.
   --  ------------------------------
   function Is_Tokenized (Field : in Field_Type) return Boolean is
   begin
      return Field.Kind = F_CONTENT;
   end Is_Tokenized;

   --  ------------------------------
   --  Create a field with the given name and content.
   --  ------------------------------
   function Create (Name  : in String;
                    Value : in String;
                    Kind  : in Field_Kind := F_TOKEN) return Field_Type is
   begin
      return Field_Type '(Kind  => Kind,
                          Name  => To_UString (Name),
                          Value => To_UString (Value));
   end Create;

end Search.Fields;
