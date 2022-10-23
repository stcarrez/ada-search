with Ada.Text_IO;
with Ada.Command_Line;
with Search.Fields;
with Search.Documents;
with Search.Indexers.Databases;
with Search.Tokenizers;
with Search.Analyzers.French;
with ADO.Sessions.Factory;
with ADO.SQLite;
with Util.Log.Loggers;
procedure Indexer is
   Log     : constant Util.Log.Loggers.Logger := Util.Log.Loggers.Create ("Indexer");

   Factory   : ADO.Sessions.Factory.Session_Factory;
   Count     : constant Natural := Ada.Command_Line.Argument_Count;
begin
   ADO.SQLite.Initialize;
   Factory.Create ("sqlite:///search.db?synchronous=OFF&encoding='UTF-8'");

   if Count < 1 then
      Ada.Text_IO.Put_Line ("Usage: indexer file...");
      return;
   end if;
   declare
      DB        : ADO.Sessions.Master_Session := Factory.Get_Master_Session;
      Indexer   : Search.Indexers.Databases.Indexer_Type;
      Analyzer  : Search.Analyzers.French.Analyzer_Type;
      Tokenizer : Search.Tokenizers.Tokenizer_Type;
   begin
      Indexer.Initialize (DB, ADO.NO_IDENTIFIER);
      for I in 1 .. Count loop
         declare
            Path : constant String := Ada.Command_Line.Argument (I);
            Doc  : Search.Documents.Document_Type;
         begin
            Doc.Add_Field ("path", Path, Search.Fields.F_PATH);
            Indexer.Add_Document (Doc, Analyzer, Tokenizer);
         end;
      end loop;
   end;
   
exception
   when E : others =>
      Log.Error ("Some internal error occurred", E);
      Log.Error (Util.Log.Loggers.Traceback (E));
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
end Indexer;
