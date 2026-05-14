{ config, lib, ... }:
let
  cfg = config.programs.nvf;
in
{
  programs.nvf.settings.vim.theme = lib.mkIf cfg.enable {
    enable = true;
    name = "catppuccin";
    style = "mocha";
    transparent = true;
  };
}
