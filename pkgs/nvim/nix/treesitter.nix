{ vimPlugins }:
let
  parsers = builtins.attrValues {
    inherit (vimPlugins.nvim-treesitter-parsers)
      bash
      editorconfig
      gitcommit
      json
      lua
      luadoc
      markdown
      nix
      toml
      typst
      vim
      vimdoc
      yaml
      ;
  };

  queries = map (parser: parser.associatedQuery) parsers;
in
parsers ++ queries
