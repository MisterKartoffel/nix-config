if vim.g.did_load_keybindings_plugin then
  return
end
vim.g.did_load_keybindings_plugin = true

local map = require("utils").map
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected string down a line and autoindent" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected string up a line and autoindent" })

map("v", "<", "<gv", { desc = "Remove indentation and maintain selection" })
map("v", ">", ">gv", { desc = "Add indentation and maintain selection" })

map("n", "J", "V<Esc>Jgv<Esc>zz", { desc = "Append line below while keeping cursor still" })
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll half page down and center screen on cursor" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll half page up and center screen on cursor" })
