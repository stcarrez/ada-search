-----------------------------------------------------------------------
--  search-tokens-tests -- Tests for tokens
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
with Search.Tokens.Factories.Default;
package body Search.Tokens.Tests is

   package Caller is new Util.Test_Caller (Test, "Search.Tokens");

   procedure Add_Tests (Suite : in Util.Tests.Access_Test_Suite) is
   begin
      Caller.Add_Test (Suite, "Test Search.Tokens.Factories",
                       Test_Create_Token'Access);
   end Add_Tests;

   procedure Test_Create_Token (T : in out Test) is
      F      : Search.Tokens.Factories.Default.Token_Factory;
      Token1 : Search.Tokens.Token_Type;
      Token2 : Search.Tokens.Token_Type;
      Token3 : Search.Tokens.Token_Type;
   begin
      F.Create ("word", Token1);

      T.Assert_Equals ("word", Token1.Get_Value, "Get_Value failed");

      F.Create ("word", Token2);
      T.Assert_Equals ("word", Token2.Get_Value, "Get_Value failed");

      T.Assert (Token1 = Token2, "Token are different");

      F.Create ("item", Token3);
      T.Assert_Equals ("item", Token3.Get_Value, "Get_Value failed");

      T.Assert (Token1 /= Token3, "Token are different");

   end Test_Create_Token;

end Search.Tokens.Tests;
