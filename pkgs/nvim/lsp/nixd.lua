if vim.fn.executable("nixd") ~= 1 or vim.fn.executable("nil") == 1 then
  return {}
end

local root_markers = {
  "flake.nix",
  "default.nix",
  "shell.nix",
}

return {
  cmd = { "nixd", },
  filetypes = { "nix", },
  root_markers = root_markers,
}
