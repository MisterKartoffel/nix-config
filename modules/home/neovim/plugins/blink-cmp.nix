{ config, lib, ... }:
let
  inherit (config.programs) nvf;
in
{
  programs.nvf.settings.vim.autocomplete.blink-cmp = lib.mkIf nvf.enable {
    enable = true;

    friendly-snippets.enable = true;
    setupOpts = {
      keymap.preset = "default";
      cmdline.keymap.preset = "default";
    };
  };
}
