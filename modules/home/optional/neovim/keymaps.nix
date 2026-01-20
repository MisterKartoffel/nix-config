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

    # Oil
    {
      mode = "n";
      key = "-";
      action = ":Oil<CR>";
      desc = "Open parent directory in Oil";
      silent = true;
    }

    # Snacks pickers
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
    {
      mode = "n";
      key = "grn";
      action = "vim.lsp.buf.rename";
      desc = "Rename current symbol";
      lua = true;
      silent = true;
    }
    {
      mode = "n";
      key = "grf";
      action = "vim.lsp.buf.format";
      desc = "Autoformat current buffer";
      lua = true;
      silent = true;
    }
    {
      mode = "n";
      key = "grh";
      action = "function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end";
      desc = "Toggle inlay hints";
      lua = true;
      silent = true;
    }
    {
      mode = "n";
      key = "K";
      action = "vim.lsp.buf.hover";
      desc = "Display hover information for current symbol";
      lua = true;
      silent = true;
    }
    {
      mode = "i";
      key = "<C-s>";
      action = "vim.lsp.buf.signature_help";
      desc = "Display signature help for current symbol";
      lua = true;
      silent = true;
    }
  ];
}
