{
  stdenvNoCC,
  lib,
  vimPlugins,
  neovim-unwrapped,
  wrapNeovimUnstable,
  tree-sitter,
  fetchFromGitHub,
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

  plugins = import ./nix/plugins.nix { inherit vimPlugins; };
  treesitter = import ./nix/treesitter.nix { inherit fetchFromGitHub tree-sitter vimPlugins; };

  extraPackages = [ ripgrep ];
in
makeNeovim {
  inherit
    plugins
    treesitter
    extraPackages
    ;
}
