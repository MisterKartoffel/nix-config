local opts = {
  flavor = "mocha",
  integrations = {
    snacks = true,
    which_key = true,
  },
}

require("lz.n").load({
  "catppuccin-nvim",
  colorscheme = { "catppuccin" },
  config = function()
    require("catppuccin").setup(opts)
  end,
})
