if vim.g.did_load_neogit_plugin then
  return
end
vim.g.did_load_neogit_plugin = true

local map = require("lz.n").keymap({
  "neogit",
  after = function()
    require("neogit").setup({})
  end,
}).set

map("n", "<leader>gg", ":Neogit<CR>", { desc = "Open Neogit", silent = true })
