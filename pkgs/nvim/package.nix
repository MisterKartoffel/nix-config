{
  lib,
  neovim-unwrapped,
  wrapNeovimUnstable,
  vimPlugins,

  plugins ? import ./plugins.nix { inherit vimPlugins; },
  excludes ? import ./excludes.nix,
}:
let
  nvimRtp = builtins.path {
    name = "nvim-rtp";
    path = ./runtime;
  };
in
(wrapNeovimUnstable neovim-unwrapped {
  inherit plugins;
  vimAlias = true;
  viAlias = true;

  wrapperArgs = [
    "--set"
    "VIMRUNTIME"
    "${placeholder "out"}/share/nvim/runtime"
  ];

  luaRcContent = /* lua */ ''
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "

    vim.opt.rtp:prepend("${nvimRtp}")
    vim.opt.rtp:append("${nvimRtp}/after")
  '';
}).overrideAttrs
  (
    oldAttrs:
    lib.optionalAttrs (excludes != [ ]) {
      postBuild =
        oldAttrs.postBuild
        + lib.concatMapStringsSep "\n" (target: "rm -f $out/share/nvim/runtime/${target}") excludes;
    }
  )
