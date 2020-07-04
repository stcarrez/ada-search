-----------------------------------------------------------------------
--  search-documents -- Documents indexed by the search engine
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
package body Search.Documents is

   --  ------------------------------
   --  Add the field to the document.
   --  ------------------------------
   procedure Add_Field (Document : in out Document_Type;
                        Field    : in Search.Fields.Field_Type) is
   begin
      Document.Fields.Append (Field);
   end Add_Field;

   --  ------------------------------
   --  Create and add the field to the document.
   --  ------------------------------
   procedure Add_Field (Document : in out Document_Type;
                        Name     : in String;
                        Value    : in String;
                        Kind     : in Search.Fields.Field_Kind) is
   begin
      Document.Fields.Append (Search.Fields.Create (Name, Value, Kind));
   end Add_Field;

   --  ------------------------------
   --  Get the field identified by the given name.
   --  ------------------------------
   function Get_Field (Document : in Document_Type;
                       Name     : in String) return Search.Fields.Field_Type is
   begin
      for Field of Document.Fields loop
         if Search.Fields.Get_Name (Field) = Name then
            return Field;
         end if;
      end loop;
      raise Field_Not_Found;
   end Get_Field;

   --  ------------------------------
   --  Returns True if the document contains the give named field.
   --  ------------------------------
   function Has_Field (Document : in Document_Type;
                       Name     : in String) return Boolean is
   begin
      for Field of Document.Fields loop
         if Search.Fields.Get_Name (Field) = Name then
            return True;
         end if;
      end loop;
      return False;
   end Has_Field;

   --  ------------------------------
   --  Iterate over the document fields.
   --  ------------------------------
   procedure Iterate (Document : in Document_Type;
                      Process  : not null access
                        procedure (Field : in Search.Fields.Field_Type)) is
   begin
      for Field of Document.Fields loop
         Process (Field);
      end loop;
   end Iterate;

end Search.Documents;
