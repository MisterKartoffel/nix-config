if vim.g.did_load_keybindings_plugin then
  return
end
vim.g.did_load_keybindings_plugin = true

local opts = { silent = true }

opts.desc = "Move selected line down and autoindent"
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)

opts.desc = "Move selected line up and autoindent"
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)

opts.desc = "Remove one level of indentation and maintain selection"
vim.keymap.set("v", "<", "<gv", opts)

opts.desc = "Add one level of indentation and maintain selection"
vim.keymap.set("v", ">", ">gv", opts)

opts.desc = "Append line below keeping cursor still"
vim.keymap.set("n", "J", "V<Esc>Jgv<Esc>zz", opts)

opts.desc = "Scroll half page down and center cursor"
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)

opts.desc = "Scroll half page up and center cursor"
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)
