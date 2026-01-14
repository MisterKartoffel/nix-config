{
	programs.nvf.settings.vim.statusline.lualine = {
		enable = true;
		icons.enable = true;

		activeSection = {
			b = [ ''
				{ "b:gitsigns_head", icon = "", },
				{ "diff", source = diff_source, },
				{ "diagnostics", },
			'' ];
			c = [ ''
				{
					"filename",
					symbols = {
						modified = "",
						readonly = "󱀰",
						unnamed = "󱀶",
						newfile = "",
					},
				}
			'' ];
			y = [ ''
				{ "filetype", },
			'' ];
		};
	};
}
