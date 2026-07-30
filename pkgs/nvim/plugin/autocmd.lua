if vim.g.did_load_autocmd_plugin then
  return
end
vim.g.did_load_autocmd_plugin = true

local api = vim.api

api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = api.nvim_create_augroup("hl_on_yank", { clear = true, }),
  callback = function()
    vim.hl.on_yank()
  end,
})

api.nvim_create_autocmd("BufWritePre", {
  desc = "Create directory when saving file",
  group = api.nvim_create_augroup("create_dir_on_save", { clear = true, }),
  callback = function()
    local dir = vim.fn.expand("<afile>:p:h")
    if not vim.fn.isdirectory(dir) then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

api.nvim_create_autocmd("BufWritePre", {
  desc = "Disable undofile for files in /tmp",
  pattern = "/tmp/*",
  group = api.nvim_create_augroup("no_undo_in_tmp", { clear = true, }),
  callback = function()
    vim.cmd.setlocal("noundofile")
  end,
})
