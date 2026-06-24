{
  programs.nvf.settings.vim.utility.oil-nvim = {
    setupOpts = {
      watch_for_changes = true;
      win_options = {
        winbar = "%!v:lua.get_oil_winbar()";
        signcolumn = "yes:2";
      };
    };

    gitStatus.enable = true;
  };
}
