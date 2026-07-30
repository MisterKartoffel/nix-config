if vim.fn.executable("nil") ~= 1 then
  return {}
end

local root_markers = {
  "flake.nix",
  "default.nix",
  "shell.nix",
}

return {
  cmd = { "nil" },
  filetypes = { "nix" },
  root_markers = root_markers,
  settings = {
    ["nil"] = {
      formatting = {
        command = vim.fn.executable("nixfmt") == 1 and { "nixfmt" } or nil,
      },
      flake = {
        autoArchive = true,
        autoEvalInputs = true,
      },
    },
  },
}
