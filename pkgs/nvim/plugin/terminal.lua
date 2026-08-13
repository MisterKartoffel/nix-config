local terminal = {
  buf = nil,
  win = nil,
  job_id = nil,
}

local map_opts = { silent = true }

local function floating_terminal()
  if terminal.win and vim.api.nvim_win_is_valid(terminal.win) then
    vim.api.nvim_win_close(terminal.win, false)
    return
  end

  if not terminal.buf or not vim.api.nvim_buf_is_valid(terminal.buf) then
    terminal.buf = vim.api.nvim_create_buf(false, true)
    vim.bo[terminal.buf].bufhidden = "hide"
    terminal.job_id = nil
  end

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  terminal.win = vim.api.nvim_open_win(terminal.buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
  })

  if not terminal.job_id then
    map_opts = {
      desc = "Close terminal from terminal mode",
      buf = terminal.buf,
    }

    vim.keymap.set("t", "<Esc>", function()
      if terminal.job_id and vim.api.nvim_win_is_valid(terminal.win) then
        vim.api.nvim_win_close(terminal.win, false)
      end
    end, map_opts)

    terminal.job_id = vim.fn.jobstart("fish", {
      term = true,
      on_exit = function()
        if vim.api.nvim_win_is_valid(terminal.win) then
          vim.api.nvim_win_close(terminal.win, true)
          vim.api.nvim_buf_delete(terminal.buf, { force = true })
        end

        terminal.win = nil
        terminal.buf = nil
        terminal.job_id = nil
      end,
    })
  end

  vim.cmd.startinsert()
end

map_opts.desc = "Toggle floating terminal"
vim.keymap.set("n", "<leader>t", floating_terminal, map_opts)
