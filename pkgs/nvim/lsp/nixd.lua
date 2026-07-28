if vim.fn.executable("nixd") ~= 1 or vim.fn.executable("nil") == 1 then
  return {}
end

local root_files = {
  "flake.nix",
  "default.nix",
  "shell.nix",
}

return {
  cmd = { "nixd", },
  filetypes = { "nix", },
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true, })[1]),
}
