{ config, lib, ... }:
let
  inherit (config.programs) nvf;
in
{
  programs.nvf.settings.vim.ui.colorizer = lib.mkIf nvf.enable {
    enable = true;
    setupOpts.filetypes."*" = {
      RRGGBBAA = true;
      css = true;
      mode = "background";
      always_update = true;
    };
  };
}
