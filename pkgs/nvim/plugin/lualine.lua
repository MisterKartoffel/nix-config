if vim.g.did_load_lualine_plugin then
  return
end
vim.g.did_load_lualine_plugin = true

-- Uses gitsigns as a source for diffs.
local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.modified,
      removed = gitsigns.removed,
    }
  end
end

local opts = {
  sections = {
    lualine_b = {
      { "b:gitsigns_head", icon = "" },
      { "diff", source = diff_source },
      { "diagnostics" },
    },
    lualine_c = {
      {
        "filename",
        symbols = {
          modified = "",
          readonly = "󱀰",
          unnamed = "󱀶",
          newfile = "",
        },
      },
    },
    lualine_x = {
      { "encoding" },
      { "fileformat" },
    },
    lualine_y = {
      { "lsp_status" },
      { "filetype" },
    },
  },
}

local lualine = require("lualine")
lualine.setup(opts)
