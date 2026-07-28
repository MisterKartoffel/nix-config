if vim.g.did_load_gitsigns_plugin then
  return
end
vim.g.did_load_gitsigns_plugin = true

local gitsigns = require("gitsigns")
gitsigns.setup({
  on_attach = function()
    local map = require("utils").map

    map("n", "[g", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[g", bang = true, })
      else
        gitsigns.nav_hunk("prev")
      end
    end, { desc = "Jump to previous hunk", silent = true, })

    map("n", "]g", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]g", bang = true, })
      else
        gitsigns.nav_hunk("next")
      end
    end, { desc = "Jump to next hunk", silent = true, })

    -- Actions
    map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage current hunk", silent = true, })
    map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset current hunk", silent = true, })
    map("v", "<leader>gs", function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
      { desc = "Stage currently selected hunk", silent = true, })
    map("v", "<leader>gr", function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
      { desc = "Reset currently selected hunk", silent = true, })
    map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage current buffer", silent = true, })
    map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset current buffer", silent = true, })
    map("n", "<leader>gv", gitsigns.preview_hunk_inline, { desc = "Preview current hunk", silent = true, })
  end,
})
