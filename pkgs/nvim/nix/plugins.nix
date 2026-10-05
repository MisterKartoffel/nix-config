{ vimPlugins }:
builtins.attrValues {
  inherit (vimPlugins)
    # keep-sorted start

    catppuccin-nvim
    gitsigns-nvim
    lualine-nvim
    lz-n
    neogit
    nvim-treesitter
    nvim-web-devicons
    oil-git-status-nvim
    oil-nvim
    snacks-nvim
    which-key-nvim

    # keep-sorted end
    ;
}
