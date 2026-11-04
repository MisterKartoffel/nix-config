local opts = {
  symbol_position = "signcolumn",
  symbols = {
    file = {
      added = "",
      modified = "",
      renamed = "",
      deleted = "󰍴",
      copied = "",
      conflict = "",
      untracked = "",
      ignored = "◌",
    },
    directory = {
      added = "",
      modified = "",
      renamed = "",
      deleted = "󰍴",
      copied = "",
      conflict = "",
      untracked = "",
      ignored = "◌",
    },
  },
}

local lzn = require("lz.n")
lzn.load({
  "oil-git.nvim",
  lazy = true,
  after = function()
    require("oil-git").setup(opts)
  end,
})
