{
  neovim-unwrapped,
  wrapNeovimUnstable,
  vimPlugins,
}:
wrapNeovimUnstable neovim-unwrapped {
  plugins = [
    {
      plugin = vimPlugins.catppuccin-nvim;
      type = "lua";
      config = ''
        require("catppuccin").setup({
        	flavour = "mocha",
        	integrations = {
        		snacks = true,
        		lualine = true,
        	},
        })

        vim.cmd.colorscheme("catppuccin")
      '';
    }
    {
      plugin = vimPlugins.gitsigns-nvim;
      type = "lua";
      config = ''
        local gitsigns = require("gitsigns")

        gitsigns.setup({
        	on_attach = function()
        		local map = vim.keymap.set
        		
        		map("n", "[g", function() gitsigns.nav_hunk("prev") end, { desc = "Jump to previous hunk", silent = true, })
        		map("n", "]g", function() gitsigns.nav_hunk("next") end, { desc = "Jump to next hunk", silent = true, })

        		-- Actions
        		map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage current hunk", silent = true, })
        		map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset current hunk", silent = true, })
        		map("v", "<leader>gs", function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
        				{ desc = "Stage currently selected hunk", silent = true, })
        		map("v", "<leader>gr", function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
        				{ desc = "Reset currently selected hunk", silent = true, })
        		map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage current buffer", silent = true, })
        		map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset current buffer", silent = true, })
        		map("n", "<leader>gv", gitsigns.preview_hunk_inline, { desc = "Preview current hunk", silent = true, })
        	end,
        })
      '';
    }
    {
      plugin = vimPlugins.oil-nvim;
      type = "lua";
      config = ''
        function _G.get_oil_winbar()
        	local path = vim.fn.expand("%")
        	path = path:gsub("oil://", "")

        	return vim.fn.fnamemodify(path, ":~")
        end

        local oil = require("oil")
        local map = vim.keymap.set

        oil.setup({
        	watch_for_changes = true,
        	view_options = { show_hidden = true, },
        	win_options = {
        		winbar = "%!v:lua.get_oil_winbar()",
        		signcolumn = "yes:2",
        	},
        })

        map("n", "-", ":Oil<CR>", { desc = "Open parent directory in Oil", })
      '';
    }
    {
      plugin = vimPlugins.oil-git-status-nvim;
      type = "lua";
      config = ''
        require("oil-git-status").setup({})
      '';
    }
    {
      plugin = vimPlugins.lualine-nvim;
      type = "lua";
      config = ''
        -- Using gitsigns as a source for diffs.
        local function diff_source()
        	local gitsigns = vim.b.gitsigns_status_dict
        	if gitsigns then
        		return {
        			added = gitsigns.added,
        			modified = gitsigns.changed,
        			removed = gitsigns.removed,
        		}
        	end
        end

        local lualine = require("lualine")

        lualine.setup({
        	sections = {
        		lualine_b = {
        			{ "b:gitsigns_head", icon = "", },
        			{ "diff", source = diff_source, },
        			{ "diagnostics", },
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
        		lualine_y = {
        			{ "lsp_status", },
        			{ "filetype", },
        		},
        	},
        })
      '';
    }
    vimPlugins.nvim-colorizer-lua
  ];
}
