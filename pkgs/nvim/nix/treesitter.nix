{ vimPlugins }:
vimPlugins.nvim-treesitter.withPlugins (
  plugins:
  builtins.attrValues {
    inherit (plugins)
      # keep-sorted start

      tree-sitter-bash
      tree-sitter-editorconfig
      tree-sitter-fish
      tree-sitter-git_config
      tree-sitter-gitcommit
      tree-sitter-gitignore
      tree-sitter-json
      tree-sitter-just
      tree-sitter-kdl
      tree-sitter-lua
      tree-sitter-luadoc
      tree-sitter-markdown
      tree-sitter-muttrc
      tree-sitter-nix
      tree-sitter-ssh_config
      tree-sitter-toml
      tree-sitter-typst
      tree-sitter-vim
      tree-sitter-vimdoc
      tree-sitter-yaml
      tree-sitter-zsh

      # keep-sorted end
      ;
  }
)
