{ config, lib, ... }:
let
  inherit (config.programs) nvf;
in
{
  programs.nvf.settings.vim.theme = lib.mkIf nvf.enable {
    enable = true;
    name = "catppuccin";
    style = "mocha";
    transparent = true;
  };
}
