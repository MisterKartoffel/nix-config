local lzn = require("lz.n")
lzn.load({
  "typst-preview-nvim",
  ft = "typst",
  after = function()
    require("typst-preview").setup()
  end,
})
