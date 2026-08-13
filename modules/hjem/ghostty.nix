{
  self,
  pkgs,
  lib,
  ...
}:
let
  packages = builtins.attrValues { inherit (pkgs) ghostty; };
in
{
  inherit packages;
  systemd = { inherit packages; };

  xdg.config.files."ghostty/config" = {
    generator = lib.generators.toKeyValue { listsAsDuplicateKeys = true; };
    value = {
      command = lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.fish;
      theme = "Catppuccin Mocha";
      font-family = "Monospace";
      font-size = 16;
      window-decoration = "none";
      resize-overlay = "never";

      confirm-close-surface = false;
      quit-after-last-window-closed = false;
      gtk-single-instance = true;

      shell-integration = "zsh";
      shell-integration-features = [
        "cursor"
        "sudo"
        "title"
      ];

      bell-features = "border";
      notify-on-command-finish = "unfocused";
      notify-on-command-finish-action = [
        "bell"
        "notify"
      ];

      keybind = [
        # Clear default keybinds
        "clear"

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
