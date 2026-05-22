{ config, ... }:
let
  inherit (config.programs) nvf;
in
{
  programs.nvf.settings.vim.treesitter.enable = nvf.enable;
}
