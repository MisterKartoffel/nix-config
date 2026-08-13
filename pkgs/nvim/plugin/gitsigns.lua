if vim.g.did_load_gitsigns_plugin then
  return
end
vim.g.did_load_gitsigns_plugin = true

local gitsigns = require("gitsigns")
gitsigns.setup({
  on_attach = function(bufnr)
    local opts = { buf = bufnr, silent = true }

    opts.desc = "Jump to previous hunk"
    vim.keymap.set("n", "[g", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[g", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end, opts)

    opts.desc = "Jump to next hunk"
    vim.keymap.set("n", "]g", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]g", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end, opts)

    -- Actions
    opts.desc = "Stage current hunk"
    vim.keymap.set("n", "<leader>gs", gitsigns.stage_hunk, opts)

    opts.desc = "Reset current hunk"
    vim.keymap.set("n", "<leader>gr", gitsigns.reset_hunk, opts)

    opts.desc = "Stage currently selected hunk"
    vim.keymap.set("v", "<leader>gs", function()
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, opts)

    opts.desc = "Reset currently selected hunk"
    vim.keymap.set("v", "<leader>gr", function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, opts)

    opts.desc = "Stage current buffer"
    vim.keymap.set("n", "<leader>gS", gitsigns.stage_buffer, opts)

    opts.desc = "Reset current buffer"
    vim.keymap.set("n", "<leader>gR", gitsigns.reset_buffer, opts)

    opts.desc = "Preview current hunk"
    vim.keymap.set("n", "<leader>gv", gitsigns.preview_hunk_inline, opts)
  end,
})
