{ config, lib, ... }:
let
  inherit (config.programs) nvf;
in
{
  programs.nvf.settings.vim.git.neogit = lib.mkIf nvf.enable {
    enable = true;

    mappings.open = "<leader>gg";
  };
}
