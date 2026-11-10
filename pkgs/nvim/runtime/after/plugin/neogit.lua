local lzn = require("lz.n")
lzn.load({
  "neogit",
  cmd = "Neogit",
  keys = {
    { "<leader>gg", vim.cmd.Neogit, desc = "Open Neogit", silent = true },
  },
  after = function()
    require("neogit").setup()
  end,
})
