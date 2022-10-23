with Ada.Text_IO;
with Ada.Command_Line;
with Search.Fields;
with Search.Documents;
with Search.Indexers.Databases;
with Search.Tokenizers;
with Search.Analyzers.French;
with Search.Results;
with ADO.Sessions.Factory;
with ADO.SQLite;
with Util.Log.Loggers;
procedure Finder is
   Log     : constant Util.Log.Loggers.Logger := Util.Log.Loggers.Create ("Indexer");

   Factory   : ADO.Sessions.Factory.Session_Factory;
   Count     : constant Natural := Ada.Command_Line.Argument_Count;
begin
   ADO.SQLite.Initialize;
   Factory.Create ("sqlite:///search.db?synchronous=OFF&encoding='UTF-8'");

   if Count < 1 then
      Ada.Text_IO.Put_Line ("Usage: finder query...");
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
            Query  : constant String := Ada.Command_Line.Argument (I);
	    Result : Search.Results.Result_Vector;
         begin
            Indexer.Search (Query, Analyzer, Tokenizer, Result);
	    for Item of Result loop
	       declare
		  Doc   : Search.Documents.Document_Type;
		  Field : Search.Fields.Field_Type;
	       begin
		  Indexer.Load (Doc, Item.Doc_Id);
		  Field := Doc.Get_Field ("path");
		  Put_Line (Search.Fields.Get_Value (Field));
	       end;
	    end loop;
         end;
      end loop;
   end;
   
exception
   when E : others =>
      Log.Error ("Some internal error occurred", E);
      Log.Error (Util.Log.Loggers.Traceback (E));
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
end Finder;
