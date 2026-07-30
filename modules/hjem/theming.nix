{ pkgs, lib, ... }:
let
  inherit (lib) toSentenceCase;

  theme = {
    variant = "mocha";
    accent = "mauve";
    shade = "dark";
  };

  cursor = {
    variant = "Modern";
    style = "Ice";
  };

  catppuccin = {
    kvantum = pkgs.catppuccin-kvantum.override { inherit (theme) accent variant; };
    gtk = pkgs.magnetic-catppuccin-gtk.override { accent = [ theme.accent ]; };
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
    "gtk-2.0".source =
      "${catppuccin.gtk}/share/themes/Catppuccin-GTK-${toSentenceCase theme.accent}-${toSentenceCase theme.shade}/gtk-2.0";
    "gtk-3.0".source =
      "${catppuccin.gtk}/share/themes/Catppuccin-GTK-${toSentenceCase theme.accent}-${toSentenceCase theme.shade}/gtk-3.0";
    "gtk-4.0".source =
      "${catppuccin.gtk}/share/themes/Catppuccin-GTK-${toSentenceCase theme.accent}-${toSentenceCase theme.shade}/gtk-4.0";

    "Kvantum/catppuccin-${theme.variant}-${theme.accent}".source =
      "${catppuccin.kvantum}/share/Kvantum/catppuccin-${theme.variant}-${theme.accent}";
    "Kvantum/kvantum.kvconfig" = {
      generator = (pkgs.formats.ini { }).generate "kvantum.kvconfig";
      value.General.theme = "catppuccin-${theme.variant}-${theme.accent}";
    };

    "zen/default/chrome/userChrome.css".source =
      "${catppuccin.zen}/themes/${toSentenceCase theme.variant}/${toSentenceCase theme.accent}/userChrome.css";
    "zen/default/chrome/userContent.css".source =
      "${catppuccin.zen}/themes/${toSentenceCase theme.variant}/${toSentenceCase theme.accent}/userContent.css";
  };

  xdg.data.files."icons/Bibata-${toSentenceCase cursor.variant}-${toSentenceCase cursor.style}".source =
    "${pkgs.bibata-cursors}/share/icons/Bibata-${toSentenceCase cursor.variant}-${toSentenceCase cursor.style}";

  environment.sessionVariables.QT_STYLE_OVERRIDE = "kvantum";
}
