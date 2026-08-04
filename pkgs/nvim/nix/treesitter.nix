{ pkgs, lib }:
let
  fallbackGrammars = {
    /*
      muttrc was dropped from nvim-treesitter:
      https://github.com/nvim-treesitter/nvim-treesitter/commit/78bebe
    */
    muttrc = pkgs.tree-sitter.buildGrammar {
      language = "muttrc";
      version = "2026-07-26";

      src = pkgs.fetchFromGitHub {
        owner = "neomutt";
        repo = "tree-sitter-muttrc";
        rev = "da8af7ba87b1bbe6d9e1606dfdc5eceb0fccc2dc";
        hash = "sha256-TR11ezKjO0HdKUKD/wMebP+Ybmw0I6PGMFMv/heEwGY=";
      };
    };
  };

  resolvedFallbacks = lib.mapAttrs (
    grammar: fallback:
    let
      available = pkgs.vimPlugins.nvim-treesitter-parsers ? ${grammar};
    in
    lib.warnIf available "${grammar} is available in nixpkgs, you may remove this fallback" (
      if available then pkgs.vimPlugins.nvim-treesitter-parsers.${grammar} else fallback
    )
  ) fallbackGrammars;
in
pkgs.vimPlugins.nvim-treesitter.withPlugins (
  plugins:
  builtins.attrValues (
    {
      inherit (plugins)
        bash
        editorconfig
        gitcommit
        gitignore
        git_config
        json
        just
        lua
        luadoc
        markdown
        nix
        ssh_config
        toml
        typst
        vim
        vimdoc
        yaml
        zsh
        ;
    }
    // resolvedFallbacks
  )
)
