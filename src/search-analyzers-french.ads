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
private with Search.Filters.Lowercase;
private with Search.Filters.Stemmers;
private with Stemmer.French;
package Search.Analyzers.French is

   type Analyzer_Type is limited new Search.Analyzers.Analyzer_Type with private;

   procedure Initialize (Analyzer : in out Analyzer_Type);

private

   package French_Stemmer_Filter is
      new Search.Filters.Stemmers (Stemmer.French.Context_Type);

   type Analyzer_Type is limited new Search.Analyzers.Analyzer_Type with record
      Lowercase : aliased Search.Filters.Lowercase.Filter_Type;
      Stemmer   : aliased French_Stemmer_Filter.Filter_Type;
   end record;

end Search.Analyzers.French;
