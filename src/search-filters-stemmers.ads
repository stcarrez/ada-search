-----------------------------------------------------------------------
--  search-filters-stemmers -- Filter to stem words
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
with Stemmer;

generic
   type Stemmer_Type is new Stemmer.Context_Type with private;
package Search.Filters.Stemmers is

   type Filter_Type is new Search.Filters.Filter_Type with record
      Context : Stemmer_Type;
   end record;

   overriding
   procedure Push_Token (Filter   : in out Filter_Type;
                         Token    : in String;
                         Consumer : not null access procedure (Token : in String));

end Search.Filters.Stemmers;
