{ inputs, ... }: {
	imports = [
		inputs.nvf.homeManagerModules.default
		./keymaps.nix
		./languages.nix
		./options.nix
		./plugins
	];

	programs.nvf = {
		enable = true;
		settings.vim = {
			extraLuaFiles = [ ./functions.lua ];

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

			visuals.nvim-web-devicons.enable = true;
			treesitter.enable = true;
			binds.whichKey.enable = true;
		};
	};
}
