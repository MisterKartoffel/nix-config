{ vimPlugins }:
vimPlugins.nvim-treesitter.withPlugins (
  plugins:
  builtins.attrValues {
    inherit (plugins)
      # keep-sorted start

      bash
      editorconfig
      git_config
      gitcommit
      gitignore
      json
      just
      kdl
      luadoc
      nix
      nu
      ssh_config
      toml
      tree-sitter-muttrc
      typst
      yaml

      # keep-sorted end
      ;
  }
)
