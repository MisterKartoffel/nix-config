if vim.g.did_load_snacks_plugin then
  return
end
vim.g.did_load_snacks_plugin = true

local opts = {
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

  image = { enabled = true },
  notifier = { enabled = true },
  picker = { enabled = true },

  statuscolumn = {
    folds = {
      open = true,
      git_hl = true,
    },
  },
}

local snacks = require("snacks")
snacks.setup(opts)

local map_opts = { silent = true }

map_opts.desc = "Find files among open buffers, recent files and files in $PWD"
vim.keymap.set("n", "<leader>ff", function()
  Snacks.picker.smart()
end, map_opts)

map_opts.desc = "Grep for string in $PWD"
vim.keymap.set("n", "<leader>fg", function()
  Snacks.picker.grep()
end, map_opts)

map_opts.desc = "Pick a picker"
vim.keymap.set("n", "<leader>fp", function()
  Snacks.picker()
end, map_opts)
