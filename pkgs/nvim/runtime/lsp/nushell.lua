if vim.fn.executable("nu") ~= 1 then
  return {}
end

return {
  cmd = { "nu", "--lsp" },
  filetypes = { "nu" },
}
