{ inputs, ... }: {
	imports = [
		inputs.nvf.homeManagerModules.default
		./languages.nix
		./options.nix
	];

	programs.nvf = {
		enable = true;
		settings.vim = {
			theme = {
				enable = true;
				name = "catppuccin";
				style = "mocha";
				transparent = true;
			};
			ui.colorizer = {
				enable = true;
				setupOpts.filetypes."*" = {
					RRGGBBAA = true;
					css = true;
					mode = "background";
					always_update = true;
				};
			};
			git.gitsigns = {
				enable = true;
				mappings = {
					previousHunk = "[g";
					nextHunk = "]g";
					stageHunk = "<leader>gs";
					resetHunk = "<leader>gr";
					stageBuffer = "<leader>gS";
					resetBuffer = "<leader>gR";
					previewHunk = "<leader>gv";
				};
			};
			statusline.lualine = {
				enable = true;
				icons.enable = true;
			};
			utility.oil-nvim = {
				enable = true;
				setupOpts = {
					watch_for_changes = true;
				};
			};
			treesitter.enable = true;
			binds.whichKey.enable = true;
		};
	};
}
