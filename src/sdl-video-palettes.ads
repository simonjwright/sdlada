--------------------------------------------------------------------------------------------------------------------
--  This source code is subject to the Zlib license, see the LICENCE file in the root of this directory.
--------------------------------------------------------------------------------------------------------------------
--  SDL.Video.Palettes
--
--  Palettes, colours and various conversions.
--------------------------------------------------------------------------------------------------------------------

with Ada.Iterator_Interfaces;
with Interfaces.C.Pointers;

package SDL.Video.Palettes is
   pragma Preelaborate;

   package C renames Interfaces.C;

   type Colour_Component is range 0 .. 255 with
     Size       => 8,
     Convention => C;

   type Colour is
      record
         Red   : Colour_Component := Colour_Component'First;
         Green : Colour_Component := Colour_Component'First;
         Blue  : Colour_Component := Colour_Component'First;
         Alpha : Colour_Component := Colour_Component'First;
      end record with
     Convention => C_Pass_by_Copy,
     Size       => Colour_Component'Size * 4;

   Null_Colour : constant Colour := (others => <>);

   pragma Warnings (Off, "8 bits of ""RGB_Colour"" unused"); --  Unused on purpose
   type RGB_Colour is
      record
         Red   : Colour_Component := Colour_Component'First;
         Green : Colour_Component := Colour_Component'First;
         Blue  : Colour_Component := Colour_Component'First;
      end record with
     Convention => C_Pass_by_Copy,
     Size       => Colour_Component'Size * 4;
   pragma Warnings (On, "8 bits of ""RGB_Colour"" unused");

   Null_RGB_Colour : constant RGB_Colour := (others => <>);

   --  Cursor type for our iterator.
   type Cursor is private;

   No_Element : constant Cursor;

   function Element (Position : in Cursor) return Colour;

   function Has_Element (Position : in Cursor) return Boolean with
     Inline;

   --  Create the iterator interface package.
   package Palette_Iterator_Interfaces is new
     Ada.Iterator_Interfaces (Cursor, Has_Element);

   type Palette is tagged limited private with
     Default_Iterator  => Iterate,
     Iterator_Element  => Colour,
     Constant_Indexing => Constant_Reference;

   type Palette_Access is access Palette;

   function Constant_Reference
     (Container : aliased Palette;
      Position  : Cursor) return Colour;

   function Iterate (Container : Palette)
                     return Palette_Iterator_Interfaces.Forward_Iterator'Class;

   function Create (Total_Colours : in Positive) return Palette;

   procedure Free (Container : in out Palette);

   Empty_Palette : constant Palette;
private

   type Colour_Array is array (C.size_t range <>) of aliased Colour with
     Convention => C;

   package Colour_Array_Pointer is new Interfaces.C.Pointers
     (Index              => C.size_t,
      Element            => Colour,
      Element_Array      => Colour_Array,
      Default_Terminator => (others => Colour_Component'First));

   type Internal_Palette is
      record
         Total     : C.int;
         Colours   : Colour_Array_Pointer.Pointer;
         Version   : Interfaces.Unsigned_32;
         Ref_Count : C.int;
      end record with
     Convention => C;

   type Internal_Palette_Access is access Internal_Palette with
     Convention => C;

   type Palette is tagged limited
      record
         Data : Internal_Palette_Access;
      end record;

   type Palette_Constant_Access is access constant Palette'Class;

   type Cursor is
      record
         Container : Palette_Constant_Access;
         Index     : Natural;
         Current   : Colour_Array_Pointer.Pointer;
      end record;

   No_Element : constant Cursor := Cursor'(Container => null,
                                           Index     => Natural'First,
                                           Current   => null);

   Empty_Palette : constant Palette := Palette'(Data => null);
end SDL.Video.Palettes;
