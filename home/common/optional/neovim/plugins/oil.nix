{
  programs.nvf.settings.vim.utility.oil-nvim = {
    enable = true;
    setupOpts = {
      watch_for_changes = true;
      win_options.winbar = "%!v:lua.get_oil_winbar()";
    };
  };
}
