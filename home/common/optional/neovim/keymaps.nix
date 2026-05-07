{ config, lib, ... }:
{
  programs.nvf.settings.vim.keymaps = [
    # Vanilla Neovim
    {
      mode = "v";
      key = "J";
      action = ":m '>+1<CR>gv=gv";
      desc = "Move selected hunk down a line and autoindent";
      silent = true;
    }
    {
      mode = "v";
      key = "K";
      action = ":m '<-2<CR>gv=gv";
      desc = "Move selected hunk up a line and autoindent";
      silent = true;
    }
    {
      mode = "n";
      key = "J";
      action = "V<Esc>Jgv<Esc>zz";
      desc = "Append the line below while keeping cursor still";
      silent = true;
    }
    {
      mode = "n";
      key = "<C-d>";
      action = "<C-d>zz";
      desc = "Scroll half page down and center screen on cursor";
      silent = true;
    }
    {
      mode = "n";
      key = "<C-u>";
      action = "<C-u>zz";
      desc = "Scroll half page up and center screen on cursor";
      silent = true;
    }
  ]
  ++ lib.mkIf config.programs.nvf.settings.vim.utility.snacks-nvim.enable [
    # Snacks LSP pickers
    {
      mode = "n";
      key = "gri";
      action = "function() Snacks.picker.lsp_implementations() end";
      desc = "Go to implementation for current symbol";
      lua = true;
      silent = true;
    }
    {
      mode = "n";
      key = "grr";
      action = "function() Snacks.picker.lsp_references() end";
      desc = "Find references for current symbol";
      lua = true;
      silent = true;
    }
    {
      mode = "n";
      key = "grd";
      action = "function() Snacks.picker.lsp_definitions() end";
      desc = "Go to definition for current symbol";
      lua = true;
      silent = true;
    }
    {
      mode = "n";
      key = "gre";
      action = "function() Snacks.picker.diagnostics() end";
      desc = "Browse diagnostics for current buffer";
      lua = true;
      silent = true;
    }
  ];
}
