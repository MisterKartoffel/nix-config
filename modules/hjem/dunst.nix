{ pkgs, lib, ... }:
let
  packages = builtins.attrValues { inherit (pkgs) dunst; };
in
{
  inherit packages;
  systemd = { inherit packages; };

  xdg.config.files."dunst/dunstrc" = {
    generator = lib.generators.toINI { };
    value = {
      global = {
        width = "(100, 300)";
        height = "(0, 300)";
        offset = "(8, 8)";
        corner_radius = 10;
        progress_bar_corners = "all";
        progress_bar_corner_radius = 5;
        icon_corners = "all";
        icon_corner_radius = 5;
        frame_width = 1;
        gap_size = 2;
        markup = "full";
        enable_recursive_icon_lookup = true;
        dmenu = "${lib.getExe' pkgs.tofi "tofi-drun"} --prompt-text 'dunst:'";
        browser = lib.getExe' pkgs.xdg-utils "xdg-open";
        mouse_left_click = "do_action, open_url, close_current";
        mouse_middle_click = "context";
        mouse_right_click = "close_current";
      };
    };
  };

  xdg.config.files."dunst/dunstrc.d/colors.conf".source = pkgs.fetchurl {
    name = "dunst-colors.conf";
    url = "https://raw.githubusercontent.com/catppuccin/dunst/refs/heads/main/themes/mocha.conf";
    hash = "sha256-v/Ger5s0WUXNUreIM3HvaBcJCR9B4lCrQQrFkW7PSIg=";
  };
}
