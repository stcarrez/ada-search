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

--  == Fields ==
--  The field describe an element of a document that can be indexed.
package Search.Fields is

   type Field_Kind is (F_TOKEN, F_PATH, F_CONTENT);

   type Field_Type is private;

   --  Get the field name.
   function Get_Name (Field : in Field_Type) return String;

   --  Returns True if this field is indexable.
   function Is_Indexable (Field : in Field_Type) return Boolean;

   --  Returns True if this field is composed of multiple tokens.
   function Is_Tokenized (Field : in Field_Type) return Boolean;

   --  Create a field with the given name and content.
   function Create (Name  : in String;
                    Value : in String;
                    Kind  : in Field_Kind := F_TOKEN) return Field_Type;

private

   type Field_Type is record
      Kind  : Field_Kind;
      Name  : UString;
      Value : UString;
   end record;

end Search.Fields;
