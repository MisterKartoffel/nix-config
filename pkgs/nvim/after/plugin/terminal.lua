local opts = { silent = true }

opts.desc = "Toggle floating terminal"
vim.keymap.set("n", "<leader>t", require("terminal").open, opts)
