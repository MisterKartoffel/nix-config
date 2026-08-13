if vim.g.did_load_options_plugin then
  return
end
vim.g.did_load_options_plugin = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Indentation
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false

-- Visual settings
vim.cmd.colorscheme("catppuccin")
vim.opt.signcolumn = "yes"
vim.opt.autocomplete = true
vim.opt.complete = { ".^5", "b^5", "t^5", "o^5" }
vim.opt.completeopt = { "fuzzy", "menuone", "popup", "noselect" }
vim.opt.wildmode = { "noselect", "full" }
vim.opt.wildignore:append({ "*/.git/*", "*/.direnv/*" })
vim.opt.showmode = false
vim.opt.winborder = "rounded"
vim.opt.pumborder = "rounded"
vim.opt.pumheight = 10
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣", extends = "›", precedes = "‹" }

-- File handling
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
local undodir = vim.fn.stdpath("cache") .. "/nvim/undo"
if not vim.fn.isdirectory(undodir) then
  vim.fn.mkdir(undodir, "p")
end
vim.opt.undodir = undodir

-- Behavior settings
vim.opt.iskeyword:append("-")
vim.opt.path:append("**")
vim.opt.mouse = "a"
vim.schedule(function()
  vim.opt.clipboard:append("unnamedplus")
end)
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.formatoptions:remove({ "c", "r", "o" })

-- Folding settings
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
