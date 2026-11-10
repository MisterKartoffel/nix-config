-- Issue: lsp completion: set border of documentation preview popup
-- https://github.com/neovim/neovim/issues/38248
-- Pull request: feat(options): support 'completepopup'
-- https://github.com/neovim/neovim/pull/40943

---@param winid integer Window ID
---@return nil
local function set_popup_border(winid)
  if winid and winid >= 0 and vim.api.nvim_win_is_valid(winid) then
    pcall(vim.api.nvim_win_set_config, winid, { border = "rounded" })
  end
end

vim.api.nvim_create_autocmd("CompleteChanged", {
  group = vim.api.nvim_create_augroup("CompletionPopupBorder", { clear = true }),
  callback = function()
    vim.schedule(function()
      local info = vim.fn.complete_info({ "preview_winid" })
      set_popup_border(info.preview_winid)
    end)
  end,
})

if vim.api.nvim__complete_set then
  local original = vim.api.nvim__complete_set
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.api.nvim__complete_set = function(index, opts)
    local windata = original(index, opts)
    set_popup_border(windata and windata.winid)
    return windata
  end
end
