if vim.g.did_load_lsp_plugin then
  return
end
vim.g.did_load_lsp_plugin = true

-- LSP setup for servers configured in lsp/*
local function defaultClientCapabilities()
  local capabilities = nil
  if capabilities then
    return capabilities
  end

  capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.semanticTokens.multilineTokenSupport = true
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

  return capabilities
end

vim.lsp.config("*", {
  root_markers = { ".git" },
  capabilities = defaultClientCapabilities(),
  on_attach = function()
    local debug = false
    if debug then
      vim.lsp.log.set_level(vim.log.levels.DEBUG)
      vim.lsp.log.set_format_func(vim.inspect)
    else
      vim.lsp.log.set_level(vim.log.levels.OFF)
    end
  end,
})

vim.diagnostic.config({
  severity_sort = true,
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "󰌵",
    },
  },
})

local lsp_configs = {}
for _, file in pairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
  local server_name = vim.fn.fnamemodify(file, ":t:r")
  table.insert(lsp_configs, server_name)
end
vim.lsp.enable(lsp_configs)

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("LSP", { clear = false }),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local map = require("utils").map

    map("n", "gri", vim.lsp.buf.implementation, { desc = "Find implementations for current symbol" })
    map("n", "grr", vim.lsp.buf.references, { desc = "Find references for current symbol" })
    map("n", "grd", vim.lsp.buf.definition, { desc = "Go to definition for current symbol" })
    map("n", "gre", vim.diagnostic.setloclist, { desc = "Browse diagnostics for current buffer" })
    map("n", "grn", vim.lsp.buf.rename, { desc = "Rename current symbol" })
    map("n", "gra", vim.lsp.buf.code_action, { desc = "Display available code actions" })
    map("n", "K", vim.lsp.buf.hover, { desc = "Display hover information for current symbol" })

    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
      map("i", "<C-Space>", vim.lsp.completion.get, { desc = "Get completion for current token" })
    end

    if client:supports_method("textDocument/diagnostic") then
      vim.diagnostic.enable()
    end

    if client:supports_method("textDocument/inlayHint") then
      map("n", "grh", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, { desc = "Toggle LSP inlay hint" })
    end

    if client:supports_method("textDocument/signatureHelp") then
      map("i", "<C-s>", vim.lsp.buf.signature_help, { desc = "Display signature help for currently hovered symbol" })
    end
  end,
})
