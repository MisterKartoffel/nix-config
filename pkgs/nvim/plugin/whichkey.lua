if vim.g.did_load_whichkey_plugin then
  return
end
vim.g.did_load_whichkey_plugin = true

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
      { "<leader>f", group = "pickers", },
      { "<leader>g", group = "git commands", },
      { "gr",        group = "LSP", },
    }
  },
}

local which_key = require("which-key")
which_key.setup(opts)

local map = require("utils").map
map("n", "<leader>?", function()
  which_key.show({ global = true })
end, { desc = "Show keymaps", })
