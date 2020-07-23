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
with Interfaces;
package body Search.Positions is

   use Ada.Streams;
   use type Interfaces.Unsigned_64;

   function LEB_Length (Value : in Interfaces.Unsigned_64) return Stream_Element_Offset;

   ALIGN_SIZE     : constant Stream_Element_Offset := 16;
   SIZE_INCREMENT : constant Stream_Element_Offset := 16;

   function Next_Length (Size : in Stream_Element_Size) return Stream_Element_Size is
      (Size + (Size / 4) + SIZE_INCREMENT);

   function Align_Length (Size : in Stream_Element_Size) return Stream_Element_Size is
      (((Size + ALIGN_SIZE - 1) / ALIGN_SIZE) * ALIGN_SIZE);

   procedure Allocate (Positions : in out Position_Type;
                       Length    : in Stream_Element_Size) is
      R : Position_Refs.Ref;
   begin
      R := Position_Refs.Create (new Position_Content_Type '(Util.Refs.Ref_Entity with
                                                             Length => Length,
                                                             Size => 0,
                                                             Last => 0,
                                                             others => <>));
      Positions := Position_Type '(R with others => <>);
   end Allocate;

   --  ------------------------------
   --  Initialize the positions with the data stream.
   --  ------------------------------
   procedure Initialize (Positions : in out Position_Type;
                         Data      : in Ada.Streams.Stream_Element_Array) is
      Len : constant Stream_Element_Size := Align_Length (Data'Length);
      R : Position_Refs.Ref;
   begin
      R := Position_Refs.Create (new Position_Content_Type '(Util.Refs.Ref_Entity with
                                                               Length => Len,
                                                             Size => Data'Length,
                                                             others => <>));
      Positions := Position_Type '(R with others => <>);
   end Initialize;

   --  ------------------------------
   --  Get the last recorded position.
   --  ------------------------------
   function Last (Positions : in Position_Type) return Natural is
   begin
      if Positions.Is_Null then
         return 0;
      else
         return Positions.Value.Last;
      end if;
   end Last;

   function LEB_Length (Value : in Interfaces.Unsigned_64) return Stream_Element_Offset is
   begin
      --                 7f  1
      --              03fff  2
      --             1fffff  3
      --            fffffff  4
      --         7 ffffffff  5
      --       3ff ffffffff  6
      --     1ffff ffffffff  7
      --    ffffff ffffffff  8
      --  7fffffff ffffffff  9
      --  ffffffff ffffffff 10
      if Value < 16#7f# then
         return 1;
      elsif Value < 16#3fff# then
         return 2;
      elsif Value < 16#1fffff# then
         return 3;
      elsif Value < 16#fffffff# then
         return 4;
      else
         return 10;
      end if;
   end LEB_Length;

   --  ------------------------------
   --  Add the position to the list of positions.
   --  ------------------------------
   procedure Add (Positions : in out Position_Type;
                  Value     : in Natural) is
      V : Interfaces.Unsigned_64;
   begin
      if Positions.Is_Null then
         Allocate (Positions, ALIGN_SIZE);
         V := Interfaces.Unsigned_64 (Value);
      else
         declare
            Item  : constant Position_Refs.Element_Accessor := Positions.Value;
         begin
            V := Interfaces.Unsigned_64 (Value - Item.Last);
            if Item.Size + LEB_Length (V) >= Item.Length then
               declare
                  Length : constant Stream_Element_Offset := Next_Length (Item.Length);
                  R      : Position_Refs.Ref;
               begin
                  R := Position_Refs.Create
                    (new Position_Content_Type '(Util.Refs.Ref_Entity with
                                                   Length => Length,
                                                 Size => Item.Size,
                                                 Last => Item.Last,
                                                 others => <>));
                  R.Value.Data (1 .. Item.Size) := Item.Data (1 .. Item.Size);
                  Positions := Position_Type '(R with others => <>);
               end;
            end if;
         end;
      end if;
      declare
         Item  : constant Position_Refs.Element_Accessor := Positions.Value;
         P     : Ada.Streams.Stream_Element_Offset := Item.Size + 1;
         U     : Interfaces.Unsigned_64;
      begin
         Item.Last := Value;
         loop
            if V < 16#07F# then
               Item.Data (P) := Ada.Streams.Stream_Element (V);
               Item.Size := P;
               return;
            end if;
            U := V and 16#07F#;
            Item.Data (P) := Ada.Streams.Stream_Element (U or 16#80#);
            P := P + 1;
            V := Interfaces.Shift_Right (V, 7);
         end loop;
      end;
   end Add;

   --  ------------------------------
   --  Give access to the packed array representing the collected positions.
   --  ------------------------------
   procedure Pack (Positions : in Position_Type;
                   Process   : not null
                     access procedure (Data : in Ada.Streams.Stream_Element_Array)) is
   begin
      Process (Positions.Value.Data (1 .. Positions.Value.Size));
   end Pack;

   --  ------------------------------
   --  Encode the value represented by <tt>Val</tt> in the stream array <tt>Into</tt> starting
   --  at position <tt>Pos</tt> in that array.  The value is encoded using LEB128 format, 7-bits
   --  at a time until all non zero bits are written.  The <tt>Last</tt> parameter is updated
   --  to indicate the position of the last valid byte written in <tt>Into</tt>.
   --  ------------------------------
   procedure Write_LEB128 (Stream : access Ada.Streams.Root_Stream_Type'Class;
                           Val    : in Interfaces.Unsigned_64) is
      V, U : Interfaces.Unsigned_64;
   begin
      V := Val;
      loop
         if V < 16#07F# then
            Ada.Streams.Stream_Element'Write (Stream, Ada.Streams.Stream_Element (V));
            return;
         end if;
         U := V and 16#07F#;
         Ada.Streams.Stream_Element'Write (Stream, Ada.Streams.Stream_Element (U or 16#80#));
         V := Interfaces.Shift_Right (V, 7);
      end loop;
   end Write_LEB128;

   --  ------------------------------
   --  Decode from the byte array <tt>From</tt> the value represented as LEB128 format starting
   --  at position <tt>Pos</tt> in that array.  After decoding, the <tt>Last</tt> index is updated
   --  to indicate the last position in the byte array.
   --  ------------------------------
   function Read_LEB128 (Stream  : access Ada.Streams.Root_Stream_Type'Class)
                        return Interfaces.Unsigned_64 is
      use type Interfaces.Unsigned_8;

      Value : Interfaces.Unsigned_64 := 0;
      V     : Interfaces.Unsigned_8;
      Shift : Integer := 0;
   begin
      loop
         V := Interfaces.Unsigned_8'Input (Stream);
         if (V and 16#80#) = 0 then
            return Interfaces.Shift_Left (Interfaces.Unsigned_64 (V), Shift) or Value;
         end if;
         V := V and 16#07F#;
         Value := Interfaces.Shift_Left (Interfaces.Unsigned_64 (V), Shift) or Value;
         Shift := Shift + 7;
      end loop;
   end Read_LEB128;

   --  ------------------------------
   --  Write the list of positions in the stream.
   --  ------------------------------
   procedure Write (Stream    : access Ada.Streams.Root_Stream_Type'Class;
                    Positions : in Position_Type) is
   begin
      if Positions.Is_Null then
         Write_LEB128 (Stream, 0);
      else
         declare
            Value : constant Position_Refs.Element_Accessor := Positions.Value;
         begin
            Write_LEB128 (Stream, Interfaces.Unsigned_64 (Value.Size));
            Write_LEB128 (Stream, Interfaces.Unsigned_64 (Value.Last));
            Stream.Write (Value.Data (1 .. Value.Size));
         end;
      end if;
   end Write;

   --  ------------------------------
   --  Read a list of positions from the stream.
   --  ------------------------------
   function Read (Stream : access Ada.Streams.Root_Stream_Type'Class)
                 return Position_Type is
      Size   : constant Stream_Element_Size := Stream_Element_Size (Read_LEB128 (Stream));
      Result : Position_Type;
   begin
      if Size > 0 then
         declare
            Length : constant Stream_Element_Size := Align_Length (Size);
            Last   : constant Natural := Natural (Read_LEB128 (Stream));
            Pos    : Ada.Streams.Stream_Element_Offset;
            R      : Position_Refs.Ref;
         begin
            R := Position_Refs.Create
              (new Position_Content_Type '(Util.Refs.Ref_Entity with
                                             Length => Length,
                                           Size => Size,
                                           Last => Last,
                                           others => <>));
            Stream.Read (R.Value.Data (1 .. Size), Pos);
            Result := Position_Type '(R with others => <>);
         end;
      end if;
      return Result;
   end Read;

end Search.Positions;
