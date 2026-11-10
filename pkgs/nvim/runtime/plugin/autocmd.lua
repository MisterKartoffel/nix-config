---@param suffix string Augroup name suffix
---@return integer - Group ID
local function augroup(suffix)
  return vim.api.nvim_create_augroup("user." .. suffix, { clear = true })
end

vim.api.nvim_create_autocmd("FileType", {
  desc = "Enable treesitter for available parsers",
  group = augroup("treesitter"),
  callback = function(args)
    local res, _ = pcall(vim.treesitter.start, args.buf)
    if res then
      vim.o.foldmethod = "expr"
      vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.o.foldlevel = 99
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Remove comment leader on <Enter>, 'o' and 'O'",
  group = augroup("formatoptions"),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = augroup("hlyank"),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Return to last edit position when opening files",
  group = augroup("editposition"),
  callback = function()
    if not vim.o.diff then
      local mark = vim.api.nvim_buf_get_mark(0, '"')
      local lcount = vim.api.nvim_buf_line_count(0)
      local line = mark[1]
      if line > 0 and line <= lcount then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Disable undofile for files in /tmp",
  pattern = "/tmp/*",
  group = augroup("noundofile"),
  callback = function()
    vim.cmd.setlocal("noundofile")
  end,
})
