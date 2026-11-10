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

local lzn = require("lz.n")
lzn.load({
  "oil.nvim",
  cmd = "Oil",
  keys = {
    { "-", vim.cmd.Oil, desc = "Open parent directory", silent = true },
  },
  after = function()
    require("oil").setup(opts)
    lzn.trigger_load("oil-git.nvim")
  end,
})
