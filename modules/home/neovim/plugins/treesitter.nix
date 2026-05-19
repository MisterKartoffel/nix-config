{ config, ... }:
let
  cfg = config.programs.nvf;
in
{
  programs.nvf.settings.vim.treesitter.enable = cfg.enable;
}
