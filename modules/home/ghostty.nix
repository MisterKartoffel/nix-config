{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.programs) ghostty;
in
{
  home.sessionVariables.TERMINAL = lib.optionalString ghostty.enable "${lib.getExe pkgs.ghostty}";

  programs.ghostty = lib.mkIf ghostty.enable {
    enableZshIntegration = true;
    clearDefaultKeybinds = true;

    settings = {
      window-decoration = "none";
      resize-overlay = "never";

      confirm-close-surface = false;
      quit-after-last-window-closed = false;

      notify-on-command-finish = "unfocused";
      notify-on-command-finish-action = "bell,notify";
      bell-features = "border";

      gtk-single-instance = true;

      keybind = [
        # General keybinds
        "alt+comma=reload_config"
        "performable:ctrl+shift+c=copy_to_clipboard"
        "performable:ctrl+shift+v=paste_from_clipboard"

        "alt+f=start_search"
        "performable:escape=end_search"
        "performable:alt+u=navigate_search:next"
        "performable:alt+d=navigate_search:previous"

        "global:super+enter=toggle_quick_terminal"

        # Font keybinds
        "alt+equal=increase_font_size:1"
        "alt+minus=decrease_font_size:1"
        "alt+zero=reset_font_size"

        # Surface keybinds
        # Close current split -> tab -> window
        "alt+q=close_surface"

        # Split keybinds
        "alt+shift+h=new_split:left"
        "alt+shift+j=new_split:down"
        "alt+shift+k=new_split:up"
        "alt+shift+l=new_split:right"

        "alt+left=resize_split:left,20"
        "alt+down=resize_split:down,20"
        "alt+up=resize_split:up,20"
        "alt+right=resize_split:right,20"

        "alt+h=goto_split:left"
        "alt+j=goto_split:bottom"
        "alt+k=goto_split:top"
        "alt+l=goto_split:right"

        # Tab keybinds
        "alt+t=new_tab"
        "alt+n=next_tab"
        "alt+p=previous_tab"
      ];
    };
  };
}
