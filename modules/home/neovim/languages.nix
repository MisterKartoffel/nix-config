{
  programs.nvf.settings.vim = {
    lsp = {
      formatOnSave = true;
      lspconfig.enable = true;

      mappings = {
        previousDiagnostic = "[d";
        nextDiagnostic = "]d";
        renameSymbol = "grn";
        codeAction = "gra";
        hover = "K";
      };

      servers."*".capabilities = {
        textDocument = {
          semanticTokens.multilineTokenSupport = true;
          completion.completionItem.snippetSupport = true;
        };

        workspace.didChangeWatchedFiles.dynamicRegistration = true;
      };
    };

    languages = {
      enableExtraDiagnostics = true;
      enableFormat = true;
      enableTreesitter = true;

      bash.enable = true;
      lua.enable = true;
      nix = {
        enable = true;
        lsp.servers = [ "nixd" ];
        format.type = [ "nixfmt" ];
      };
    };
  };
}
