{ config, lib, ... }:
let
  cfg = config.programs.nvf.settings.vim;
  pluginEnabled = builtins.any (x: x.enable) [
    cfg.autocomplete.blink-cmp
    cfg.ui.lualine
    cfg.utility.oil-nvim
    cfg.utility.snacks-nvim
  ];
in
{
  programs.nvf.settings.vim.visuals.nvim-web-devicons.enable = lib.mkIf pluginEnabled true;
}
