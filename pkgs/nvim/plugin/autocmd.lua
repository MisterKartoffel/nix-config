if vim.g.did_load_autocmd_plugin then
  return
end
vim.g.did_load_autocmd_plugin = true

vim.api.nvim_create_autocmd("FileType", {
  desc = "Enable treesitter for available parsers",
  group = vim.api.nvim_create_augroup("enable_treesitter", { clear = true }),
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = vim.api.nvim_create_augroup("hl_on_yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Return to last edit position when opening files",
  group = vim.api.nvim_create_augroup("edit_position", { clear = true }),
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
  desc = "Create directory when saving file",
  group = vim.api.nvim_create_augroup("create_dir_on_save", { clear = true }),
  callback = function()
    local dir = vim.fn.expand("<afile>:p:h")
    if not vim.fn.isdirectory(dir) then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Disable undofile for files in /tmp",
  pattern = "/tmp/*",
  group = vim.api.nvim_create_augroup("no_undo_in_tmp", { clear = true }),
  callback = function()
    vim.cmd.setlocal("noundofile")
  end,
})
