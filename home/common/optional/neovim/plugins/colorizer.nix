{
  programs.nvf.settings.vim.ui.colorizer = {
    enable = true;
    setupOpts.filetypes."*" = {
      RRGGBBAA = true;
      css = true;
      mode = "background";
      always_update = true;
    };
  };
}
