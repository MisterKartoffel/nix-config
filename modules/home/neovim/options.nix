{ config, lib, ... }:
let
  cfg = config.programs.nvf;
in
{
  programs.nvf.settings.vim = lib.mkIf cfg.enable {
    clipboard = {
      enable = true;
      providers.wl-copy.enable = true;
      registers = "unnamedplus";
    };

    options = {
      scrolloff = 8;
      sidescrolloff = 8;
      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
      expandtab = false;
      smartindent = true;
      ignorecase = true;
      smartcase = true;
      hlsearch = false;
      wrap = false;
      signcolumn = "yes";
      complete = ".^5,b^5,t^5,o^5";
      completeopt = "fuzzy,menuone,popup,noselect";
      wildmode = "noselect,full";
      autocomplete = true;
      showmode = false;
      winborder = "rounded";
      pumheight = 10;
      pumblend = 10;
      writebackup = false;
      swapfile = false;
      splitright = true;
      splitbelow = true;
      inccommand = "split";
      foldmethod = "expr";
      foldexpr = "v:lua.vim.treesitter.foldexpr()";
      foldlevel = 99;
    };
  };
}
