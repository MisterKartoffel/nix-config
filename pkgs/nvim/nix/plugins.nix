{ vimPlugins }:
let
  patched = vimPlugins.extend (
    _: prev: {
      /*
        typst-preview-nvim is originally overridden to include tinymist
        and websocat in postPatch, this removes that as I expect those
        dependencies to be provided by the environment.
      */
      typst-preview-nvim = prev.typst-preview-nvim.overrideAttrs (_: {
        postPatch = null;
      });
    }
  );
in
builtins.attrValues {
  inherit (patched)
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
    typst-preview-nvim
    which-key-nvim

    # keep-sorted end
    ;
}
