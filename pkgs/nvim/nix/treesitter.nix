{ vimPlugins }:
vimPlugins.nvim-treesitter.withPlugins (
  plugins:
  builtins.attrValues {
    inherit (plugins)
      # keep-sorted start

      bash
      editorconfig
      fish
      git_config
      gitcommit
      gitignore
      json
      just
      kdl
      lua
      luadoc
      markdown
      muttrc
      nix
      ssh_config
      toml
      typst
      vim
      vimdoc
      yaml
      zsh

      # keep-sorted end
      ;
  }
)
