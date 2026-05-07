{
  programs.nvf.settings.vim = {
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
