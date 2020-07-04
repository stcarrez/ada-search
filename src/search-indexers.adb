-----------------------------------------------------------------------
--  search-indexers -- Search engine indexer
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

package body Search.Indexers is

   --  ------------------------------
   --  Add the field in the index.  The field content is not tokenized.
   --  ------------------------------
   procedure Add_Field (Indexer  : in out Indexer_Type;
                        Document : in Search.Documents.Document_Type'Class;
                        Field    : in Search.Fields.Field_Type) is
   begin
      null;
   end Add_Field;

   --  ------------------------------
   --  Add the field in the index and use the analyzer for its analysis.
   --  ------------------------------
   procedure Add_Field (Indexer  : in out Indexer_Type;
                        Document : in Search.Documents.Document_Type'Class;
                        Field    : in Search.Fields.Field_Type;
                        Analyzer : in out Search.Analyzers.Analyzer_Type'Class) is
   begin
      null;
   end Add_Field;

   --  ------------------------------
   --  Add the document in the index by storing and indexing all indexable fields.
   --  ------------------------------
   procedure Add_Document (Indexer  : in out Indexer_Type;
                           Document : in Search.Documents.Document_Type'Class;
                           Analyzer : in out Search.Analyzers.Analyzer_Type'Class) is
      procedure Index_Field (Field : in Search.Fields.Field_Type);

      procedure Index_Field (Field : in Search.Fields.Field_Type) is
      begin
         Indexer.Add_Field (Document, Field, Analyzer);
      end Index_Field;

   begin
      Document.Iterate (Index_Field'Access);
   end Add_Document;

end Search.Indexers;
