{
  vimPlugins,
  vimUtils,
  fetchFromGitHub,
}:
let
  /*
    This plugin is currently set up in ../plugin/himalaya.lua as a mock,
    since it's waiting to be updated to support Himalaya v2.*
  */
  himalaya-nvim = vimUtils.buildVimPlugin {
    pname = "himalaya-nvim";
    version = "2026-08-19";

    src = fetchFromGitHub {
      owner = "xav-ie";
      repo = "himalaya-nvim";
      rev = "576102bd3e1db2285ca3f40b99f3536c254d34db";
      hash = "sha256-MYwfZjJBciAFCwC4t9Z5RLtCaIs7XEVV8B3AGVlhQbo=";
    };
  };
in
builtins.attrValues {
  inherit (vimPlugins)
    catppuccin-nvim
    gitsigns-nvim
    lualine-nvim
    lz-n
    neogit
    nvim-treesitter
    nvim-web-devicons
    oil-git-status-nvim
    oil-nvim
    snacks-nvim
    which-key-nvim
    ;

  inherit himalaya-nvim;
}
