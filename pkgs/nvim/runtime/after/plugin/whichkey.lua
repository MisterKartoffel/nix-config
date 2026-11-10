local opts = {
  delay = 200,
  preset = "helix",

  keys = {
    scroll_up = "<C-p>",
    scroll_down = "<C-n>",
  },

  spec = {
    {
      mode = { "n" },
      { "<leader>f", group = "pickers" },
      { "<leader>g", group = "git commands" },
      { "gr", group = "LSP" },
    },
  },
}

local lzn = require("lz.n")
lzn.load({
  "which-key.nvim",
  event = "DeferredUIEnter",
  after = function()
    require("which-key").setup(opts)
  end,
})

local map_opts = { silent = true }

map_opts.desc = "Show keymaps"
vim.keymap.set("n", "<leader>?", function()
  require("which-key").show({ global = true })
end, map_opts)
