if vim.fn.executable("just-lsp") ~= 1 then
  return {}
end

return {
  cmd = { "just-lsp" },
  filetypes = { "just" },
}
