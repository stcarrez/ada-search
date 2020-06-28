-----------------------------------------------------------------------
--  search-filters -- Search engine filters
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

package body Search.Filters is

   overriding
   procedure Push_Token (Chain  : in out Filter_Type;
                         Token  : in String) is
   begin
      Chain.Next.Push_Token (Token);
   end Push_Token;

   procedure Add_Filter (Chain  : in out Filter_Chain;
                         Filter : in Filter_Type_Access) is
   begin
      Filter.Next := Chain.Next;
      Chain.Next := Filter;
   end Add_Filter;

end Search.Filters;
