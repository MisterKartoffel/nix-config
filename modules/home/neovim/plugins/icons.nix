{ config, ... }:
let
  inherit (config.programs.nvf.settings) vim;
in
{
  programs.nvf.settings.vim.visuals.nvim-web-devicons.enable = builtins.any (plugin: plugin.enable) [
    vim.statusline.lualine
    vim.utility.oil-nvim
    vim.utility.snacks-nvim
  ];
}
