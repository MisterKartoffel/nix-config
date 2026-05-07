{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages =
    lib.optionals config.programs.nvf.settings.vim.utility.snacks-nvim.enable builtins.attrValues
      { inherit (pkgs) ripgrep; };

  imports = [
    inputs.nvf.homeManagerModules.default
    ./plugins
  ];

  programs.nvf = {
    enable = true;
    settings.vim.extraLuaFiles = [ ./lua/functions.lua ];
  };
}
