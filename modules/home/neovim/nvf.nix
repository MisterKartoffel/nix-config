{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.nvf;
in
{
  home.packages =
    lib.optionals config.programs.nvf.settings.vim.utility.snacks-nvim.enable builtins.attrValues
      { inherit (pkgs) ripgrep; };

  imports = [ inputs.nvf.homeManagerModules.default ];

  programs.nvf = lib.mkIf cfg.enable {
    defaultEditor = true;
    settings.vim.extraLuaFiles = [ ./lua/functions.lua ];
  };
}
