let
	languageSettings = {
		enable = true;
		extraDiagnostics.enable = true;
		format.enable = true;
		lsp.enable = true;
		treesitter.enable = true;
	};
in {
	programs.nvf.settings.vim = {
		lsp = {
			enable = true;
			lspconfig.enable = true;
			mappings = {
				listImplementations = "gri";
				listReferences = "grr";
				goToDefinition = "grd";
				previousDiagnostic = "[d";
				nextDiagnostic = "]d";
				renameSymbol = "grn";
				codeAction = "gra";
				hover = "K";
			};
		};

		languages = {
			bash = languageSettings;
			lua = languageSettings;
			nix = languageSettings;
		};
	};
}
