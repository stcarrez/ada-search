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
with Ada.Unchecked_Deallocation;
package body Search.Positions is

   use Ada.Streams;
   use type Interfaces.Unsigned_64;

   function LEB_Length (Value : in Interfaces.Unsigned_64) return Stream_Element_Offset;

   procedure Free is
      new Ada.Unchecked_Deallocation (Object => Ada.Streams.Stream_Element_Array,
                                      Name   => Data_Access);

   SIZE_INCREMENT : constant Stream_Element_Offset := 16;

   function Next_Length (Size : in Stream_Element_Offset) return Stream_Element_Offset is
      (Size + (Size / 4) + SIZE_INCREMENT);

   --  ------------------------------
   --  Initialize the positions with the data stream.
   --  ------------------------------
   procedure Initialize (Positions : in out Position_Type;
                         Data      : in Ada.Streams.Stream_Element_Array) is
   begin
      Free (Positions.Data);
      Positions.Data := new Ada.Streams.Stream_Element_Array '(Data);
      Positions.Length := Data'Length;
   end Initialize;

   --  ------------------------------
   --  Get the last recorded position.
   --  ------------------------------
   function Last (Positions : in Position_Type) return Natural is
   begin
      return Positions.Last;
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
      P : Ada.Streams.Stream_Element_Offset;
      V, U : Interfaces.Unsigned_64;
   begin
      P := Positions.Length + 1;
      V := Interfaces.Unsigned_64 (Value - Positions.Last);
      if Positions.Data = null or else P + LEB_Length (V) > Positions.Data'Last then
         declare
            Old : Data_Access := Positions.Data;
            Len : constant Stream_Element_Offset := Next_Length (Positions.Length);
         begin
            Positions.Data := new Ada.Streams.Stream_Element_Array (1 .. Len);
            if Old /= null then
               Positions.Data (1 .. Positions.Length) := Old (1 .. Positions.Length);
               Free (Old);
            end if;
         end;
      end if;
      Positions.Last := Value;
      loop
         if V < 16#07F# then
            Positions.Data (P) := Ada.Streams.Stream_Element (V);
            Positions.Length := P;
            return;
         end if;
         U := V and 16#07F#;
         Positions.Data (P) := Ada.Streams.Stream_Element (U or 16#80#);
         P := P + 1;
         V := Interfaces.Shift_Right (V, 7);
      end loop;
   end Add;

   --  ------------------------------
   --  Give access to the packed array representing the collected positions.
   --  ------------------------------
   procedure Pack (Positions : in Position_Type;
                   Process   : not null
                     access procedure (Data : in Ada.Streams.Stream_Element_Array)) is
   begin
      Process (Positions.Data (1 .. Positions.Length));
   end Pack;

   overriding
   procedure Finalize (Positions : in out Position_Type) is
   begin
      Free (Positions.Data);
   end Finalize;

end Search.Positions;
