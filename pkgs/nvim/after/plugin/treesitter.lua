local lzn = require("lz.n")
lzn.load({
  "nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  after = function()
    require("nvim-treesitter").setup()
  end,
})
