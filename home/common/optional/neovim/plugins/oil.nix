{
  programs.nvf.settings.vim = {
    utility.oil-nvim = {
      enable = true;
      setupOpts = {
        watch_for_changes = true;
        win_options = {
          winbar = "%!v:lua.get_oil_winbarbar()";
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
