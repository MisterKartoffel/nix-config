vim.g.did_load_himalaya_plugin = true
if vim.g.did_load_himalaya_plugin then
  return
end
vim.g.did_load_himalaya_plugin = true

local opts = {
  icons_enabled = true,
}

local himalaya = require("himalaya")
himalaya.setup(opts)
