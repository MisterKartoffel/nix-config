let
  languageSettings = {
    enable = true;
  };
in
{
  programs.nvf.settings.vim = {
    lsp = {
      enable = true;
      formatOnSave = true;
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

      servers = {
        "*" = {
          capabilities = {
            textDocument = {
              semanticTokens.multilineTokenSupport = true;
              completion.completionItem.snippetSupport = true;
            };

            workspace.didChangeWatchedFiles.dynamicRegistration = true;
          };
        };
      };
    };

    languages = {
      enableExtraDiagnostics = true;
      enableFormat = true;
      enableTreesitter = true;

      bash.enable = true;
      lua.enable = true;
      nix.enable = true;
    };
  };
}
