-----------------------------------------------------------------------
--  search-filters-lowercase -- Filter to convert a word into lower case
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
with Ada.Characters.Handling;
package body Search.Filters.Lowercase is

   overriding
   procedure Push_Token (Filter   : in out Filter_Type;
                         Token    : in String;
                         Consumer : not null access procedure (Token : in String)) is
      use Ada.Characters.Handling;
   begin
      Search.Filters.Filter_Type (Filter).Push_Token (To_Lower (Token), Consumer);
   end Push_Token;

end Search.Filters.Lowercase;
