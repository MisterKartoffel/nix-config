{ vimPlugins }:
/*
  This plugin is currently disabled due to neovimRequirePluginCheck errors

  let
    himalaya-nvim = vimUtils.buildVimPlugin {
      pname = "himalaya.nvim";
      version = "2026-09-03";

      src = fetchFromGitHub {
        owner = "knownasnaffy";
        repo = "himalaya.nvim";
        rev = "1ad45468fdb44cc705ec6d69f0d389b233e7b14e";
        hash = "sha256-wFM4SEmjbzovbbnLsUwsHiHv8SYKWWs6OHMFJ3AfRHY=";
      };
    };
  in
*/
builtins.attrValues {
  inherit (vimPlugins)
    # keep-sorted start

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

    # keep-sorted end
    ;
}
