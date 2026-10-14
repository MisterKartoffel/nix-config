local map = require("lz.n").keymap({
  "neogit",
  after = function()
    require("neogit").setup({})
  end,
}).set

local opts = { silent = true }

opts.desc = "Open Neogit"
map("n", "<leader>gg", vim.cmd.Neogit, opts)
