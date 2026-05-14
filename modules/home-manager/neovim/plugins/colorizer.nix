{ config, lib, ... }:
let
  cfg = config.programs.nvf;
in
{
  programs.nvf.settings.vim.ui.colorizer = lib.mkIf cfg.enable {
    enable = true;
    setupOpts.filetypes."*" = {
      RRGGBBAA = true;
      css = true;
      mode = "background";
      always_update = true;
    };
  };
}
