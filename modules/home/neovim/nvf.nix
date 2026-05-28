{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.programs) nvf;
in
{
  home.packages =
    lib.optionals config.programs.nvf.settings.vim.utility.snacks-nvim.enable builtins.attrValues
      { inherit (pkgs) ripgrep; };

  home.sessionVariables.MANPAGER = lib.optionalString nvf.enable "${lib.getExe nvf.finalPackage}";

  imports = [ inputs.nvf.homeManagerModules.default ];

  programs.nvf = lib.mkIf nvf.enable {
    defaultEditor = true;
    settings.vim.extraLuaFiles = [ ./lua/functions.lua ];
  };
}
