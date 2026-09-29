{ pkgs, ... }:
{
  xdg.config.files = {
    "gtk-3.0".source = "${pkgs.magnetic-catppuccin-gtk}/share/themes/Catppuccin-GTK-Mauve-Dark/gtk-3.0";
    "gtk-4.0".source = "${pkgs.magnetic-catppuccin-gtk}/share/themes/Catppuccin-GTK-Mauve-Dark/gtk-4.0";

    "Kvantum/catppuccin-mocha-mauve".source =
      "${pkgs.catppuccin-kvantum}/share/Kvantum/catppuccin-mocha-mauve";
    "Kvantum/kvantum.kvconfig" = {
      generator = (pkgs.formats.ini { }).generate "kvantum.kvconfig";
      value = {
        General.theme = "catppuccin-mocha-mauve";
      };
    };

    "zen/default/chrome/userChrome.css".source =
      "${pkgs.catppuccin-zen}/themes/Mocha/Mauve/userChrome.css";
    "zen/default/chrome/userContent.css".source =
      "${pkgs.catppuccin-zen}/themes/Mocha/Mauve/userContent.css";
  };

  xdg.data.files."icons/Bibata-Modern-Ice".source =
    "${pkgs.bibata-cursors}/share/icons/Bibata-Modern-Ice";
}
