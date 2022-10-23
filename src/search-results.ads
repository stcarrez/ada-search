-----------------------------------------------------------------------
--  search-results -- Results of a search
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
with Ada.Containers.Vectors;
with Search.Documents;

--  == Results ==
--  The `Result_Type` describe a result found by the query.
package Search.Results is

   type Score_Type is digits 6 range 0.0 .. 1.0;

   type Result_Type is record
      Doc_Id : Search.Documents.Document_Identifier_Type;
      Score  : Score_Type;
   end record;

   package Result_Vectors is
     new Ada.Containers.Vectors (Element_Type => Result_Type,
				 Index_Type   => Positive);

end Search.Results;
