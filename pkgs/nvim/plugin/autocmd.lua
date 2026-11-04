vim.api.nvim_create_autocmd("FileType", {
  desc = "Enable treesitter for available parsers",
  group = vim.api.nvim_create_augroup("Enable Treesitter", { clear = true }),
  callback = function(args)
    local res, _ = pcall(vim.treesitter.start, args.buf)
    if res then
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.wo.foldlevel = 99
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Remove comment leader on <Enter>, 'o' and 'O'",
  group = vim.api.nvim_create_augroup("Format options", { clear = true }),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = vim.api.nvim_create_augroup("Highlight on yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Return to last edit position when opening files",
  group = vim.api.nvim_create_augroup("Last edit position", { clear = true }),
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
  group = vim.api.nvim_create_augroup("Create directory on save", { clear = true }),
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
  group = vim.api.nvim_create_augroup("Disable undo in /tmp", { clear = true }),
  callback = function()
    vim.cmd.setlocal("noundofile")
  end,
})
