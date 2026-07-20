{
  neovim-unwrapped,
  wrapNeovimUnstable,
  vimPlugins,
  lib,
}:
wrapNeovimUnstable neovim-unwrapped {
  plugins = [
    {
      plugin = vimPlugins.catppuccin-nvim;
      type = "lua";
      config = ''
        require("catppuccin").setup(${
          lib.generators.toLua { } {
            flavour = "mocha";
            integrations.snacks = true;
          }
        })
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
        	options = { theme = "catppuccin", },
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
