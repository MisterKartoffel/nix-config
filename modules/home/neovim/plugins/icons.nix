{ config, lib, ... }:
let
  inherit (config.programs.nvf.settings) vim;
  pluginEnabled = builtins.any (x: x.enable) [
    vim.autocomplete.blink-cmp
    vim.ui.lualine
    vim.utility.oil-nvim
    vim.utility.snacks-nvim
  ];
in
{
  programs.nvf.settings.vim.visuals.nvim-web-devicons.enable = lib.mkIf pluginEnabled true;
}
