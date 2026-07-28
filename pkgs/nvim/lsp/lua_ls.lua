if vim.fn.executable("lua-language-server") ~= 1 then
  return {}
end

local root_markers = {
  ".luarc.json",
  ".luarc.jsonc",
  ".luacheckrc",
  ".stylua.toml",
  "stylua.toml",
  "selene.toml",
  "selene.yml",
}

return {
  cmd = { "lua-language-server", },
  root_markers = root_markers,
  filetypes = { "lua", },
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = { "lua/?.lua", "lua/?/init.lua", },
      },
      diagnostics = {
        globals = { "vim", "Snacks", },
      },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME, },
      },
      telemetry = { enable = false, },
      hint = { enable = true, },
    },
  },
}
