{ config, ... }:
let
  inherit (config.programs.nvf.settings) vim;
  pluginEnabled = builtins.any (x: x.enable) [
    vim.ui.lualine
    vim.utility.oil-nvim
    vim.utility.snacks-nvim
  ];
in
{
  programs.nvf.settings.vim.visuals.nvim-web-devicons.enable = pluginEnabled;
}
