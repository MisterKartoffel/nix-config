local opts = {
  flavor = "mocha",
  auto_integrations = false,
  integrations = {
    which_key = true,
  },
}

require("lz.n").load({
  "catppuccin-nvim",
  event = "UIEnter",
  after = function()
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
})
