{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.programs) nvf;
  inherit (nvf.settings.vim.utility) snacks-nvim;
in
{
  imports = [ inputs.nvf.homeManagerModules.default ];

  home = {
    packages = lib.optionals snacks-nvim.enable builtins.attrValues { inherit (pkgs) ripgrep; };
    sessionVariables.MANPAGER = lib.optionalString nvf.enable "${lib.getExe nvf.finalPackage} '+Man!'";
  };

  programs.nvf = {
    defaultEditor = true;

    settings.vim = {
      extraLuaFiles = [ ./lua/functions.lua ];

      binds.whichKey.enable = true;
      git.gitsigns.enable = true;
      git.neogit.enable = true;
      lsp.enable = true;
      statusline.lualine.enable = true;
      theme.enable = true;
      treesitter.enable = true;
      ui.colorizer.enable = true;
      utility.oil-nvim.enable = true;
      utility.snacks-nvim.enable = true;
    };
  };
}
