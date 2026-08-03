{
  vimPlugins,
}:
vimPlugins.nvim-treesitter.withPlugins (
  plugins:
  builtins.attrValues {
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
)
