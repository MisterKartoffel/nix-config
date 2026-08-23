{ pkgs, ... }:
let
  catppuccin = {
    gtk = pkgs.magnetic-catppuccin-gtk.override {
      accent = [ "mauve" ];
    };
    kvantum = pkgs.catppuccin-kvantum.override {
      variant = "mocha";
      accent = "mauve";
    };
    zen = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "zen-browser";
      rev = "c855685442c6040c4dda9c8d3ddc7b708de1cbaa";
      hash = "sha256-5A57Lyctq497SSph7B+ucuEyF1gGVTsuI3zuBItGfg4=";
    };
  };
in
{
  xdg.config.files = {
    "gtk-3.0".source = "${catppuccin.gtk}/share/themes/Catppuccin-GTK-Mauve-Dark/gtk-3.0";
    "gtk-4.0".source = "${catppuccin.gtk}/share/themes/Catppuccin-GTK-Mauve-Dark/gtk-4.0";

    "Kvantum/catppuccin-mocha-mauve".source =
      "${catppuccin.kvantum}/share/Kvantum/catppuccin-mocha-mauve";
    "Kvantum/kvantum.kvconfig" = {
      generator = (pkgs.formats.ini { }).generate "kvantum.kvconfig";
      value = {
        General.theme = "catppuccin-mocha-mauve";
      };
    };

    "zen/default/chrome/userChrome.css".source = "${catppuccin.zen}/themes/Mocha/Mauve/userChrome.css";
    "zen/default/chrome/userContent.css".source =
      "${catppuccin.zen}/themes/Mocha/Mauve/userContent.css";
  };

  xdg.data.files."icons/Bibata-Modern-Ice".source =
    "${pkgs.bibata-cursors}/share/icons/Bibata-Modern-Ice";
}
