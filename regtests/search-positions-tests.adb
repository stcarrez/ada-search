-----------------------------------------------------------------------
--  search-positions-tests -- Tests for positions
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
package body Search.Positions.Tests is

   package Caller is new Util.Test_Caller (Test, "Search.Positions");

   procedure Add_Tests (Suite : in Util.Tests.Access_Test_Suite) is
   begin
      Caller.Add_Test (Suite, "Test Search.Positions.Add",
                       Test_Add_Positions'Access);
   end Add_Tests;

   procedure Test_Add_Positions (T : in out Test) is
      P      : Position_Type;
   begin
      Util.Tests.Assert_Equals (T, 0, Last (P), "Invalid Last value");

      Add (P, 1);

      Util.Tests.Assert_Equals (T, 1, Last (P), "Invalid Last value");

   end Test_Add_Positions;

end Search.Positions.Tests;
