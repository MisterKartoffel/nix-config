_: final: prev: {
  magnetic-catppuccin-gtk = prev.magnetic-catppuccin-gtk.override {
    accent = [ "mauve" ];
  };

  catppuccin-kvantum = prev.catppuccin-kvantum.override {
    variant = "mocha";
    accent = "mauve";
  };

  catppuccin-zen = final.fetchFromGitHub {
    owner = "catppuccin";
    repo = "zen-browser";
    rev = "c855685442c6040c4dda9c8d3ddc7b708de1cbaa";
    hash = "sha256-5A57Lyctq497SSph7B+ucuEyF1gGVTsuI3zuBItGfg4=";
  };
}
