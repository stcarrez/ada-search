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
with Ada.Streams.Stream_IO;
with Ada.Strings.Unbounded.Hash;

with Util.Streams.Files;
with Util.Streams.Buffered;
package body Search.Fields is

   --  ------------------------------
   --  Get the field name.
   --  ------------------------------
   function Get_Name (Field : in Field_Type) return String is
   begin
      return To_String (Field.Name);
   end Get_Name;

   --  ------------------------------
   --  Get the field value for the meta field.
   --  ------------------------------
   function Get_Value (Field : in Field_Type) return String is
   begin
      if not Is_Stored (Field) then
         return "";
      else
         return To_String (Field.Value);
      end if;
   end Get_Value;

   --  ------------------------------
   --  Returns True if this field is indexable.
   --  ------------------------------
   function Is_Indexable (Field : in Field_Type) return Boolean is
   begin
      return Field.Kind = F_TOKEN or Field.Kind = F_PATH or Field.Kind = F_CONTENT;
   end Is_Indexable;

   --  ------------------------------
   --  Returns True if this field is composed of multiple tokens.
   --  ------------------------------
   function Is_Tokenized (Field : in Field_Type) return Boolean is
   begin
      return Field.Kind = F_CONTENT or Field.Kind = F_PATH;
   end Is_Tokenized;

   --  ------------------------------
   --  Returns True if this field is stored in the index.
   --  ------------------------------
   function Is_Stored (Field : in Field_Type) return Boolean is
   begin
      return Field.Kind = F_Path;
   end Is_Stored;

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

   --  ------------------------------
   --  Stream the content of the field to the procedure.
   --  ------------------------------
   procedure Stream (Field : in Field_Type;
                     Into  : not null access
                       procedure (S : in out Util.Streams.Input_Stream'Class)) is
   begin
      case Field.Kind is
         when F_PATH =>
            declare
               Stream : Util.Streams.Files.File_Stream;
            begin
               Stream.Open (Ada.Streams.Stream_IO.In_File, To_String (Field.Value));
               Into (Stream);
               Stream.Close;
            end;

         when F_CONTENT =>
            declare
               Stream : Util.Streams.Buffered.Input_Buffer_Stream;
            begin
               Stream.Initialize (To_String (Field.Value));
               Into (Stream);
            end;

         when others =>
            null;

      end case;
   end Stream;

   --  ------------------------------
   --  Create a hash on the field on its name only.
   --  ------------------------------
   function Hash (Field : in Field_Type) return Ada.Containers.Hash_Type is
   begin
      return Ada.Strings.Unbounded.Hash (Field.Name);
   end Hash;

end Search.Fields;
