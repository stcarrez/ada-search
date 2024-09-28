-----------------------------------------------------------------------
--  search-tokenizers-tests -- Tests for tokenizers
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
with Util.Strings.Sets;
package Search.Tokenizers.Tests is

   procedure Add_Tests (Suite : in Util.Tests.Access_Test_Suite);

   type Test is new Util.Tests.Test and Consumer_Type With record
      Set : Util.Strings.Sets.Set;
   end record;

   overriding
   procedure Push_Token (Filter   : in out Test;
                         Token    : in String;
                         Consumer : not null
                           access procedure (Token : in String));

   procedure Test_Simple_Tokenizer (T : in out Test);

end Search.Tokenizers.Tests;
