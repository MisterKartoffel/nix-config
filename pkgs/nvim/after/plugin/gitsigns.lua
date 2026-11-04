local lzn = require("lz.n")
lzn.load({
  "gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  after = function()
    local gitsigns = require("gitsigns")
    gitsigns.setup({
      on_attach = function(bufnr)
        local map_opts = { buf = bufnr, silent = true }

        map_opts.desc = "Jump to previous hunk"
        vim.keymap.set("n", "[g", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[g", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, map_opts)

        map_opts.desc = "Jump to next hunk"
        vim.keymap.set("n", "]g", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]g", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end, map_opts)

        -- Actions
        map_opts.desc = "Stage current hunk"
        vim.keymap.set("n", "<leader>gs", gitsigns.stage_hunk, map_opts)

        map_opts.desc = "Reset current hunk"
        vim.keymap.set("n", "<leader>gr", gitsigns.reset_hunk, map_opts)

        map_opts.desc = "Stage currently selected hunk"
        vim.keymap.set("v", "<leader>gs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, map_opts)

        map_opts.desc = "Reset currently selected hunk"
        vim.keymap.set("v", "<leader>gr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, map_opts)

        map_opts.desc = "Stage current buffer"
        vim.keymap.set("n", "<leader>gS", gitsigns.stage_buffer, map_opts)

        map_opts.desc = "Reset current buffer"
        vim.keymap.set("n", "<leader>gR", gitsigns.reset_buffer, map_opts)

        map_opts.desc = "Preview current hunk"
        vim.keymap.set("n", "<leader>gv", gitsigns.preview_hunk_inline, map_opts)
      end,
    })
  end,
})
