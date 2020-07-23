-----------------------------------------------------------------------
--  search-positions -- Token positions
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
with Ada.Streams;

private with Util.Refs;

--  == Positions ==
--  A compact data structure intended to record the positions of a token with a document field.
--  While indexing a document field, the token position is added to the list.  It is expected
--  that a new token position is always greater or equal than previous one.
package Search.Positions is

   type Position_Type is tagged private;

   --  Initialize the positions with the data stream.
   procedure Initialize (Positions : in out Position_Type;
                         Data      : in Ada.Streams.Stream_Element_Array);

   --  Get the last recorded position.
   function Last (Positions : in Position_Type) return Natural;

   --  Add the position to the list of positions.
   procedure Add (Positions : in out Position_Type;
                  Value     : in Natural) with
     Pre => Value >= Last (Positions);

   --  Give access to the packed array representing the collected positions.
   procedure Pack (Positions : in Position_Type;
                   Process   : not null
                     access procedure (Data : in Ada.Streams.Stream_Element_Array));

   --  Write the list of positions in the stream.
   procedure Write (Stream    : access Ada.Streams.Root_Stream_Type'Class;
                    Positions : in Position_Type);

   --  Read a list of positions from the stream.
   function Read (Stream : access Ada.Streams.Root_Stream_Type'Class)
                 return Position_Type;

private

   subtype Stream_Element_Size is
     Ada.Streams.Stream_Element_Offset range 0 .. Ada.Streams.Stream_Element_Offset'Last;

   type Position_Content_Type (Length : Stream_Element_Size) is limited new Util.Refs.Ref_Entity
     with record
      Size   : Stream_Element_Size := 0;
      Last   : Natural := 0;
      Data   : Ada.Streams.Stream_Element_Array (1 .. Length);
   end record;
   type Position_Content_Access is access all Position_Content_Type'Class;

   package Position_Refs is
     new Util.Refs.Indefinite_References (Element_Type   => Position_Content_Type'Class,
                                          Element_Access => Position_Content_Access);

   type Position_Type is new Position_Refs.Ref with null record;

end Search.Positions;
