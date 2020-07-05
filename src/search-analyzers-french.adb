-----------------------------------------------------------------------
--  search-analyzers-french -- French document analysis
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

package body Search.Analyzers.French is

   procedure Initialize (Analyzer : in out Analyzer_Type) is
   begin
      Analyzer.Filters.Add_Filter (Analyzer.Lowercase'Unchecked_Access);
      Analyzer.Filters.Add_Filter (Analyzer.Stemmer'Unchecked_Access);
   end Initialize;

end Search.Analyzers.French;
