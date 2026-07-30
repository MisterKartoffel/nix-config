if vim.g.did_load_snacks_plugin then
  return
end
vim.g.did_load_snacks_plugin = true

local snacks = require("snacks")
snacks.setup({
  dashboard = {
    preset = {
      header = [[
      ████ ██████           █████      ██⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
     ███████████             █████ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
     █████████ ███████████████████ ███   ███████████⠀⠀
    █████████  ███    █████████████ █████ ██████████████⠀⠀
   █████████ ██████████ █████████ █████ █████ ████ █████⠀⠀
 ███████████ ███    ███ █████████ █████ █████ ████ █████⠀
██████  █████████████████████ ████ █████ █████ ████ ██████
      ]],
      pick = "fzf-lua",
    },
    sections = {
      { section = "header" },
      { section = "keys", icon = " ", title = "Keymaps", indent = 2, padding = 1 },
      { section = "recent_files", icon = " ", title = "Recent Files", indent = 2, padding = 1 },
    },
  },

  notifier = { enabled = true },
  picker = { enabled = true },

  statuscolumn = {
    folds = {
      open = true,
      git_hl = true,
    },
  },
})

local map = require("utils").map
map("n", "<leader>ff", function()
  Snacks.picker.smart()
end, { desc = "Find files among open buffers, recent files and files in $PWD" })

map("n", "<leader>fg", function()
  Snacks.picker.grep()
end, { desc = "Grep for string in $PWD" })

map("n", "<leader>fp", function()
  Snacks.picker()
end, { desc = "Pick a picker" })
