{ config, lib, ... }:
let
  cfg = config.programs.nvf;
in
{
  programs.nvf.settings.vim.autocomplete.blink-cmp = lib.mkIf cfg.enable {
    enable = true;

    friendly-snippets.enable = true;
    setupOpts = {
      keymap.preset = "default";
      cmdline.keymap.preset = "default";
    };
  };
}
