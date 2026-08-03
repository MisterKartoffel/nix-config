{
  fetchFromGitHub,
  tree-sitter,
  vimPlugins,
}:
let
  /*
    muttrc was dropped from nvim-treesitter:
    https://github.com/nvim-treesitter/nvim-treesitter/commit/78bebe
  */
  muttrc = tree-sitter.buildGrammar {
    language = "muttrc";
    version = "2026-07-26";

    src = fetchFromGitHub {
      owner = "neomutt";
      repo = "tree-sitter-muttrc";
      rev = "da8af7ba87b1bbe6d9e1606dfdc5eceb0fccc2dc";
      hash = "sha256-TR11ezKjO0HdKUKD/wMebP+Ybmw0I6PGMFMv/heEwGY=";
    };
  };
in
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
  ++ [ muttrc ]
)
