{
  vimPlugins,
  vimUtils,
}:
let
  makeNvimPlugin =
    src: pname:
    vimUtils.buildVimPlugin {
      inherit src pname;
      version = src.lastModifiedDate;
      doCheck = false;
    };

  patchNvimPlugin =
    src: pname: patches:
    (makeNvimPlugin src pname).overrideAttrs (_: {
      inherit patches;
    });
in
with vimPlugins;
[
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
]
