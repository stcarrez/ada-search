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
with Ada.Finalization;

with Search.Fields.Vectors;

--  == Documents ==
--  Documents contains fields that can be indexed by the search engine.  It may also
--  contain other fields that are not indexed but are useful to identify the document.
package Search.Documents is

   Field_Not_Found : exception;

   type Document_Type is limited new Ada.Finalization.Limited_Controlled with private;

   --  Add the field to the document.
   procedure Add_Field (Document : in out Document_Type;
                        Field    : in Search.Fields.Field_Type);

   --  Create and add the field to the document.
   procedure Add_Field (Document : in out Document_Type;
                        Name     : in String;
                        Value    : in String;
                        Kind     : in Search.Fields.Field_Kind);

   --  Get the field identified by the given name.
   function Get_Field (Document : in Document_Type;
                       Name     : in String) return Search.Fields.Field_Type;

   --  Returns True if the document contains the give named field.
   function Has_Field (Document : in Document_Type;
                       Name     : in String) return Boolean;

   --  Iterate over the document fields.
   procedure Iterate (Document : in Document_Type;
                      Process  : not null access
                        procedure (Field : in Search.Fields.Field_Type));

private

   type Document_Type is limited new Ada.Finalization.Limited_Controlled with record
     Fields : Search.Fields.Vectors.Vector;
   end record;

end Search.Documents;
