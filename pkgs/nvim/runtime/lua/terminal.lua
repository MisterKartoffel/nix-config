local M = {}

---@class TerminalState
---@field buf integer? Terminal buffer handle
---@field win integer? Floating window handle
---@field job_id integer? Shell job ID

---@type TerminalState
local terminal = {
  buf = nil,
  win = nil,
  job_id = nil,
}

---@return integer? Terminal window handle, if it is open
local function get_win()
  if terminal.win and vim.api.nvim_win_is_valid(terminal.win) then
    return terminal.win
  end
end

---@return vim.api.keyset.win_config
local function float_config()
  local width = math.max(1, math.floor(vim.o.columns * 0.8))
  local height = math.max(1, math.floor(vim.o.lines * 0.8))
  return {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
  }
end

---@param force? boolean Whether to forcefully close the buffer
local function close(force)
  local win = get_win()
  if win then
    vim.api.nvim_win_close(win, force or false)
  end
  terminal.win = nil
end

---@param buf integer Buffer to attach the shell job to
local function start_job(buf)
  vim.keymap.set({ "n", "t" }, "<Esc>", function()
    close()
  end, { buf = buf, desc = "Close terminal" })

  terminal.job_id = vim.fn.jobstart("nu", {
    term = true,
    on_exit = function()
      close(true)
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
      terminal.buf, terminal.job_id = nil, nil
    end,
  })
end

--- Toggle the floating terminal
function M.open()
  if get_win() then
    close()
    return
  end

  local buf = terminal.buf
  if not (buf and vim.api.nvim_buf_is_valid(buf)) then
    buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].bufhidden = "hide"
    terminal.buf, terminal.job_id = buf, nil
  end

  local config = float_config()
  config.style = "minimal"
  terminal.win = vim.api.nvim_open_win(buf, true, config)

  vim.api.nvim_create_autocmd("VimResized", {
    group = vim.api.nvim_create_augroup("Resize terminal", { clear = true }),
    callback = function()
      local win = get_win()
      if not win then
        return true
      end
      vim.api.nvim_win_set_config(win, float_config())
    end,
  })

  if not terminal.job_id then
    start_job(buf)
  end

  vim.cmd.startinsert()
end

return M
