{
  stdenvNoCC,
  lib,
  vimPlugins,
  vimUtils,
  neovim-unwrapped,
  wrapNeovimUnstable,
  ripgrep,
}:
let
  makeNeovim = import ./nix/wrapper.nix {
    inherit
      stdenvNoCC
      lib
      neovim-unwrapped
      wrapNeovimUnstable
      ;
  };

  plugins = import ./nix/plugins.nix { inherit vimPlugins vimUtils; };
  treesitter = import ./nix/treesitter.nix { inherit vimPlugins; };

  extraPackages = [ ripgrep ];
in
makeNeovim {
  inherit
    plugins
    treesitter
    extraPackages
    ;
}
