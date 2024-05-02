--------------------------------------------------------------------------------------------------------------------
--  This source code is subject to the Zlib license, see the LICENCE file in the root of this directory.
--------------------------------------------------------------------------------------------------------------------
--  SDL_Linker
--------------------------------------------------------------------------------------------------------------------
package SDL_Linker is
   pragma Pure;

   pragma Linker_Options ("-F/Library/Frameworks");
   pragma Linker_Options ("-framework");
   pragma Linker_Options ("SDL2");

end SDL_Linker;
