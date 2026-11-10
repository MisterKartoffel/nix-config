{ vimPlugins }:
let
  opt = map (plugin: {
    inherit plugin;
    optional = true;
  });
in
with vimPlugins;
(
  [ lz-n ]
  ++ opt [
    # keep-sorted start

    (import ./treesitter.nix { inherit vimPlugins; })
    catppuccin-nvim
    gitsigns-nvim
    lualine-nvim
    neogit
    nvim-web-devicons
    oil-git-nvim
    oil-nvim
    snacks-nvim
    typst-preview-nvim
    which-key-nvim

    # keep-sorted end
  ]
)
