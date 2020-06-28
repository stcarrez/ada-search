-----------------------------------------------------------------------
--  search-analyzers -- Analyze a document
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
with Ada.Finalization;
with Util.Streams;
with Search.Filters;
with Search.Tokenizers;
package Search.Analyzers is

   type Analyzer_Type is limited new Ada.Finalization.Limited_Controlled with private;
   type Analyzer_Type_Access is access all Analyzer_Type'Class;

   procedure Analyze (Analyzer  : in out Analyzer_Type;
                      Tokenizer : in out Search.Tokenizers.Tokenizer_Type'Class;
                      Stream    : in out Util.Streams.Input_Stream'Class);

private

   type Analyzer_Type is limited new Ada.Finalization.Limited_Controlled with record
      Filters    : Search.Filters.Filter_Chain;
   end record;

end Search.Analyzers;
