if vim.fn.executable("tinymist") ~= 1 then
  return {}
end

---@param command_name string
---@param client vim.lsp.Client
---@param bufnr integer
---@return fun():nil run_tinymist_command, string cmd_name, string cmd_desc
local function create_tinymist_command(command_name, client, bufnr)
  local raw_name = command_name:match("tinymist%.(.+)") or ""
  local cmd_display = raw_name:gsub("^export", "Export to "):gsub("^get", "Get "):gsub("^pin", "Pin ")

  local cmd_name = "Tinymist" .. raw_name:sub(1, 1):upper() .. raw_name:sub(2)
  local cmd_desc = cmd_display

  local function run_tinymist_command()
    local arguments = { vim.api.nvim_buf_get_name(bufnr) }

    local function handler(err, res)
      if err then
        return vim.notify(err.code .. ": " .. err.message, vim.log.levels.ERROR)
      end

      vim.notify(vim.inspect(res), vim.log.levels.INFO)
    end

    return client:exec_cmd({
      title = cmd_desc,
      command = command_name,
      arguments = arguments,
    }, { bufnr = bufnr }, handler)
  end

  return run_tinymist_command, cmd_name, cmd_desc
end

---@type vim.lsp.Config
return {
  cmd = { "tinymist" },
  filetypes = { "typst" },
  on_attach = function(client, bufnr)
    for _, command in ipairs({
      -- keep-sorted start

      "tinymist.exportAnsiHighlight",
      "tinymist.exportHtml",
      "tinymist.exportMarkdown",
      "tinymist.exportPdf",
      "tinymist.exportPng",
      "tinymist.exportQuery",
      "tinymist.exportSvg",
      "tinymist.exportText",
      "tinymist.getDocumentMetrics",
      "tinymist.getDocumentTrace",
      "tinymist.getServerInfo",
      "tinymist.getWorkspaceLabels",
      "tinymist.pinMain",

      -- keep-sorted end
    }) do
      local cmd_func, cmd_name, cmd_desc = create_tinymist_command(command, client, bufnr)
      vim.api.nvim_buf_create_user_command(bufnr, cmd_name, cmd_func, { nargs = 0, desc = cmd_desc })
    end
  end,
}
