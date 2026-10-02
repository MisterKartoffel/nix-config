if vim.fn.executable("yaml-language-server") ~= 1 then
  return {}
end

return {
  cmd = function(dispatchers)
    local cmd = "yaml-language-server"
    return vim.lsp.rpc.start({ cmd, "--stdio" }, dispatchers)
  end,
  filetypes = { "yaml" },
  settings = {
    redhat = {
      telemetry = { enabled = false },
    },
  },
}
