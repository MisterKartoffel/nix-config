if vim.g.did_load_lsp_plugin then
  return
end
vim.g.did_load_lsp_plugin = true

local debug = false
if debug then
  vim.lsp.log.set_level(vim.log.levels.DEBUG)
  vim.lsp.log.set_format_func(vim.inspect)
else
  vim.lsp.log.set_level(vim.log.levels.OFF)
end

-- LSP setup for servers configured in lsp/*
local function default_capabilities()
  return vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {
    textDocument = {
      semanticTokens = { multilineTokenSupport = true },
      completion = {
        completionItem = { snippetSupport = true },
      },
    },
    workspace = {
      didChangeWatchedFiles = { dynamicRegistration = true },
    },
  })
end

vim.lsp.config("*", {
  root_markers = { ".git" },
  capabilities = default_capabilities(),
})

vim.diagnostic.config({
  severity_sort = true,
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float({
        bufnr = bufnr,
        scope = "cursor",
        focus = false,
      })
    end,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
  },
})

local lsp_configs = {}
for _, file in ipairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
  local server_name = vim.fn.fnamemodify(file, ":t:r")
  table.insert(lsp_configs, server_name)
end
vim.lsp.enable(lsp_configs)

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("LSP", { clear = true }),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local opts = { buf = args.buf, silent = true }

    opts.desc = "Find implementation for current symbol"
    vim.keymap.set("n", "gri", vim.lsp.buf.implementation, opts)

    opts.desc = "Find references for current symbol"
    vim.keymap.set("n", "grr", vim.lsp.buf.references, opts)

    opts.desc = "Go to definition for current symbol"
    vim.keymap.set("n", "grd", vim.lsp.buf.definition, opts)

    opts.desc = "Browse diagnostics for current buffer"
    vim.keymap.set("n", "gre", vim.diagnostic.setloclist, opts)

    opts.desc = "Rename current symbol"
    vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts)

    opts.desc = "Display available code actions"
    vim.keymap.set("n", "gra", vim.lsp.buf.code_action, opts)

    opts.desc = "Display hover information for current symbol"
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })

      opts.desc = "Get completion for current token"
      vim.keymap.set("i", "<C-Space>", vim.lsp.completion.get, opts)
    end

    if client:supports_method("textDocument/diagnostic") then
      vim.diagnostic.enable()

      opts.desc = "Jump to previous diagnostic"
      vim.keymap.set("n", "[d", function()
        vim.diagnostic.jump({ count = -1 })
      end, opts)

      opts.desc = "Jump to next diagnostic"
      vim.keymap.set("n", "]d", function()
        vim.diagnostic.jump({ count = 1 })
      end, opts)
    end

    if client:supports_method("textDocument/inlayHint") then
      opts.desc = "Toggle LSP inlay hint"
      vim.keymap.set("n", "grh", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }), { bufnr = args.buf })
      end, opts)
    end

    if client:supports_method("textDocument/signatureHelp") then
      opts.desc = "Display signature help for currently hovered symbol"
      vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts)
    end
  end,
})
