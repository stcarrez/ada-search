-----------------------------------------------------------------------
--  search-tokens -- Search engine token representation
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

package body Search.Tokens.Compare is

   function "=" (Left, Right : in Token_Type) return Boolean is
   begin
      if Left.Is_Null then
         return Right.Is_Null;
      end if;

      if Right.Is_Null then
         return False;
      end if;

      return Left.Get_Value = Right.Get_Value;
   end "=";

   function "<" (Left, Right : in Token_Type) return Boolean is
   begin
      if Left.Is_Null then
         return True;
      end if;

      if Right.Is_Null then
         return False;
      end if;

      return Left.Get_Value < Right.Get_Value;
   end "<";

end Search.Tokens.Compare;
