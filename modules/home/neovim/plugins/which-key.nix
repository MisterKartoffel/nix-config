{ config, lib, ... }:
let
  inherit (config.programs) nvf;
in
{
  programs.nvf.settings.vim = lib.mkIf nvf.enable {
    binds.whichKey.enable = true;

    keymaps = [
      {
        mode = "n";
        key = "<leader>?";
        action = "function() require(\"which-key\").show({ global = true }) end";
        desc = "Show keymaps";
        lua = true;
        silent = true;
      }
    ];
  };
}
