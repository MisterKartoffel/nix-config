local opts = {
  dependencies_bin = {
    ["tinymist"] = "tinymist",
    ["websocat"] = "websocat",
  },
}

local lzn = require("lz.n")
lzn.load({
  "typst-preview-nvim",
  ft = "typst",
  after = function()
    require("typst-preview").setup(opts)
  end,
})
