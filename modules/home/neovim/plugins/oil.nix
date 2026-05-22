{ config, lib, ... }:
let
  inherit (config.programs) nvf;
in
{
  programs.nvf.settings.vim = lib.mkIf nvf.enable {
    utility.oil-nvim = {
      enable = true;
      setupOpts = {
        watch_for_changes = true;
        win_options = {
          winbar = "%!v:lua.get_oil_winbar()";
          signcolumn = "yes:2";
        };
      };

      gitStatus.enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "-";
        action = ":Oil<CR>";
        desc = "Open parent directory in Oil";
        silent = true;
      }
    ];
  };
}
