-----------------------------------------------------------------------
--  search-fields-tests -- Tests for tokens
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
package body Search.Fields.Tests is

   package Caller is new Util.Test_Caller (Test, "Search.Fields");

   procedure Add_Tests (Suite : in Util.Tests.Access_Test_Suite) is
   begin
      Caller.Add_Test (Suite, "Test Search.Fields.Create",
                       Test_Create_Field'Access);
      Caller.Add_Test (Suite, "Test Search.Fields.Stream",
                       Test_Stream_Field'Access);
   end Add_Tests;

   procedure Test_Create_Field (T : in out Test) is
      Field  : Field_Type;
   begin
      --  F_TOKEN field
      Field := Create ("author", "Tolkien");

      T.Assert_Equals ("author", Get_Name (Field), "Get_Name invalid");
      T.Assert (Is_Indexable (Field), "Is_Indexable failed");
      T.Assert (not Is_Tokenized (Field), "Is_Tokenized failed");

      --  F_META field
      Field := Create ("ident", "123", F_META);

      T.Assert_Equals ("ident", Get_Name (Field), "Get_Name invalid");
      T.Assert (not Is_Indexable (Field), "Is_Indexable failed");
      T.Assert (not Is_Tokenized (Field), "Is_Tokenized failed");

      --  F_CONTENT field
      Field := Create ("title", "Lord of the Rings", F_CONTENT);

      T.Assert_Equals ("title", Get_Name (Field), "Get_Name invalid");
      T.Assert (Is_Indexable (Field), "Is_Indexable failed");
      T.Assert (Is_Tokenized (Field), "Is_Tokenized failed");

   end Test_Create_Field;

   procedure Test_Stream_Field (T     : in out Test;
                                Field : in Field_Type) is
      procedure Read (Stream : in out Util.Streams.Input_Stream'Class);

      procedure Read (Stream : in out Util.Streams.Input_Stream'Class) is
         Data : Ada.Streams.Stream_Element_Array (1 .. 100);
         Last : Ada.Streams.Stream_Element_Offset;
      begin
         Stream.Read (Data, Last);
         Util.Tests.Assert_Equals (T, Length (Field.Value), Natural (Last), "Invalid length");
      end Read;

   begin
      Stream (Field, Read'Access);
   end Test_Stream_Field;

   procedure Test_Stream_Field (T : in out Test) is
      Field  : Field_Type;
   begin
      Field := Create ("test", "some content");
      Test_Stream_Field (T, Field);
   end Test_Stream_Field;

end Search.Fields.Tests;
