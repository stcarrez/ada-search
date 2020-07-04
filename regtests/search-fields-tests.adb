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

with Util.Tests;
with Util.Test_Caller;
package body Search.Fields.Tests is

   package Caller is new Util.Test_Caller (Test, "Search.Fields");

   procedure Add_Tests (Suite : in Util.Tests.Access_Test_Suite) is
   begin
      Caller.Add_Test (Suite, "Test Search.Fields.Create",
                       Test_Create_Field'Access);
   end Add_Tests;

   procedure Test_Create_Field (T : in out Test) is
      Field  : Field_Type;
   begin
      Field := Create ("author", "Tolkien");

      T.Assert_Equals ("author", Get_Name (Field), "Get_Name invalid");
      T.Assert (Is_Indexable (Field), "Is_Indexable failed");
      T.Assert (not Is_Tokenized (Field), "Is_Tokenized failed");
   end Test_Create_Field;

end Search.Fields.Tests;
