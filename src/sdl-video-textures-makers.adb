--------------------------------------------------------------------------------------------------------------------
--  This source code is subject to the Zlib license, see the LICENCE file in the root of this directory.
--------------------------------------------------------------------------------------------------------------------
with Ada.Unchecked_Conversion;
with Interfaces.C;
private with SDL.C_Pointers;
with SDL.Error;

package body SDL.Video.Textures.Makers is
   package C renames Interfaces.C;

   use type SDL.C_Pointers.Texture_Pointer;

   function Get_Internal_Surface (Self : in SDL.Video.Surfaces.Surface)
                                  return SDL.Video.Surfaces.Internal_Surface_Pointer with
     Import     => True,
     Convention => Ada;

   function Get_Internal_Renderer (Self : in SDL.Video.Renderers.Renderer) return SDL.C_Pointers.Renderer_Pointer with
     Import     => True,
     Convention => Ada;

   procedure Create
     (Tex      : in out Texture;
      Renderer : in SDL.Video.Renderers.Renderer;
      Format   : in SDL.Video.Pixel_Formats.Pixel_Format_Names;
      Kind     : in Kinds;
      Size     : in SDL.Positive_Sizes) is

      --  Convert the Pixel_Format_Name to an Unsigned_32 because the compiler is changing the value somewhere along
      --  the lines from the start of this procedure to calling SDL_Create_Texture.
      function To_Unsigned32 is new Ada.Unchecked_Conversion (Source => SDL.Video.Pixel_Formats.Pixel_Format_Names,
                                                              Target => Interfaces.Unsigned_32);

      function SDL_Create_Texture
        (R      : in SDL.C_Pointers.Renderer_Pointer;
         Format : in Interfaces.Unsigned_32;
         Kind   : in Kinds;
         W, H   : in C.int) return SDL.C_Pointers.Texture_Pointer with
        Import        => True,
        Convention    => C,
        External_Name => "SDL_CreateTexture";

   begin
      Tex.Internal := SDL_Create_Texture (Get_Internal_Renderer (Renderer),
                                          To_Unsigned32 (Format),
                                          Kind,
                                          Size.Width,
                                          Size.Height);

      if Tex.Internal = null then
         raise Texture_Error with SDL.Error.Get;
      end if;

      Tex.Size         := Size;
      Tex.Pixel_Format := Format;
   end Create;

   procedure Create
     (Tex      : in out Texture;
      Renderer : in SDL.Video.Renderers.Renderer;
      Surface  : in SDL.Video.Surfaces.Surface) is

      function SDL_Create_Texture_From_Surface (R : in SDL.C_Pointers.Renderer_Pointer;
                                                S : in SDL.Video.Surfaces.Internal_Surface_Pointer)
                                                return SDL.C_Pointers.Texture_Pointer with
        Import        => True,
        Convention    => C,
        External_Name => "SDL_CreateTextureFromSurface";
   begin
      Tex.Internal := SDL_Create_Texture_From_Surface (Get_Internal_Renderer (Renderer),
                                                       Get_Internal_Surface (Surface));

      if Tex.Internal = null then
         raise Texture_Error with SDL.Error.Get;
      end if;
   end Create;
end SDL.Video.Textures.Makers;
