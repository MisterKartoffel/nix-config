{ config, lib, ... }:
let
  inherit (config.programs.nvf.settings.vim) binds utility;
  inherit (binds) whichKey;
  inherit (utility) oil-nvim snacks-nvim;
in
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
      action = "V<Esc>Jgv<Esc>";
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
  ++ lib.optionals oil-nvim.enable [
    {
      mode = "n";
      key = "-";
      action = ":Oil<CR>";
      desc = "Open parent directory in Oil";
      silent = true;
    }
  ]
  ++ lib.optionals snacks-nvim.enable [
    # Pickers
    {
      mode = "n";
      key = "<leader>fs";
      action = "function() Snacks.picker.smart() end";
      desc = "Find files among open buffers, recent files and files in cwd";
      lua = true;
      silent = true;
    }
    {
      mode = "n";
      key = "<leader>fg";
      action = "function() Snacks.picker.grep() end";
      desc = "Grep for string in cwd";
      lua = true;
      silent = true;
    }
    {
      mode = "n";
      key = "<leader>fp";
      action = "function() Snacks.picker() end";
      desc = "Pick a picker";
      lua = true;
      silent = true;
    }

    # LSP
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
  ]
  ++ lib.optionals whichKey.enable [
    {
      mode = "n";
      key = "<leader>?";
      action = "function() require(\"which-key\").show({ global = true }) end";
      desc = "Show keymaps";
      lua = true;
      silent = true;
    }
  ];
}
