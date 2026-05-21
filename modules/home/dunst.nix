{ pkgs, lib, ... }:
{
  services.dunst = {
    settings = {
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
        dmenu = "${lib.getExe pkgs.fuzzel} --dmenu -p dunst";
        browser = "${pkgs.xdg-utils}/bin/xdg-open";
        mouse_left_click = "do_action, open_url, close_current";
        mouse_middle_click = "context";
        mouse_right_click = "close_current";
      };
    };
  };
}
