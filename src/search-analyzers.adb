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
package body Search.Analyzers is

   procedure Analyze (Analyzer  : in out Analyzer_Type;
                      Tokenizer : in out Search.Tokenizers.Tokenizer_Type'Class;
                      Stream    : in out Util.Streams.Input_Stream'Class;
                      Consume   : not null access procedure (Token : in String)) is
   begin
      Tokenizer.Parse (Stream, Analyzer.Filters, Consume);
   end Analyze;

   procedure Analyze (Analyzer  : in out Analyzer_Type;
                      Tokenizer : in out Search.Tokenizers.Tokenizer_Type'Class;
                      Field     : in Search.Fields.Field_Type;
                      Consume   : not null access procedure (Token : in String)) is
      procedure Reader (Stream : in out Util.Streams.Input_Stream'Class);

      procedure Reader (Stream : in out Util.Streams.Input_Stream'Class) is
      begin
         Analyzer.Analyze (Tokenizer, Stream, Consume);
      end Reader;

   begin
      Search.Fields.Stream (Field, Reader'Access);
   end Analyze;

end Search.Analyzers;
