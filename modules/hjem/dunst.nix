{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  packages = builtins.attrValues { inherit (pkgs) dunst; };
  systemd.packages = builtins.attrValues { inherit (pkgs) dunst; };

  xdg.config.files."dunst/dunstrc" = {
    generator = lib.generators.toGitINI;
    value =
      let
        inherit (inputs.basix.schemeData.base24.catppuccin-mocha) palette;
      in
      {
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
          browser = "${lib.getExe' pkgs.xdg-utils "xdg-open"}";
          mouse_left_click = "do_action, open_url, close_current";
          mouse_middle_click = "context";
          mouse_right_click = "close_current";

          separator_color = palette.base02;
        };

        urgency_low = {
          background = palette.base01;
          foreground = palette.base05;
          frame_color = palette.base03;
          highlight = palette.base03;
        };

        urgency_normal = {
          background = palette.base01;
          foreground = palette.base05;
          frame_color = palette.base0D;
          highlight = palette.base0D;
        };

        urgency_critical = {
          background = palette.base01;
          foreground = palette.base05;
          frame_color = palette.base08;
          highlight = palette.base08;
        };
      };
  };
}
