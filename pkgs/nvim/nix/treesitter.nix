{ vimPlugins }:
let
  parsers = builtins.attrValues {
    inherit (vimPlugins.nvim-treesitter-parsers)
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
  };

  queries = map (parser: parser.associatedQuery) parsers;
in
parsers ++ queries
