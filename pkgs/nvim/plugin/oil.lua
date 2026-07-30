if vim.g.did_load_oil_plugin then
  return
end
vim.g.did_load_oil_plugin = true

function _G.get_oil_winbar()
  local path = vim.fn.expand("%")
  path = path:gsub("oil://", "")

  return vim.fn.fnamemodify(path, ":~")
end

local opts = {
  watch_for_changes = true,
  win_options = {
    winbar = "%!v:lua.get_oil_winbar()",
    signcolumn = "yes:2",
  },
}

local map = require("lz.n").keymap({
  "oil",
  after = function()
    require("oil").setup(opts)
    require("oil-git-status").setup({})
  end,
}).set

map("n", "-", ":Oil<CR>", { desc = "Open parent directory in Oil", silent = true })
