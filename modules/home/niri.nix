{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}:
let
  toKDL = lib.hm.generators.toKDL { };
  inherit (osConfig.programs) niri;
  zen-browser = config.programs.zen-browser.package;
in
{
  xdg.configFile."niri/config.kdl" = lib.mkIf niri.enable {
    onChange = "${lib.getExe pkgs.niri} validate";
    text = toKDL {
      prefer-no-csd = { };
      screenshot-path = "/tmp/niri-screenshot.png";
      clipboard.disable-primary = { };
      recent-windows.off = { };

      hotkey-overlay = {
        skip-at-startup = { };
        hide-not-bound = { };
      };

      input = {
        disable-power-key-handling = { };
        focus-follows-mouse._props.max-scroll-amount = "0%";

        keyboard = {
          numlock = { };

          xkb = {
            layout = "br";
            options = "caps:escape_shifted_capslock";
          };
        };
      };

      window-rule._children = [
        { match._props.title = "Picture-in-Picture"; }
        { match._props.app-id = "xdg-desktop-portal-gtk"; }
        {
          match._props.app-id = "vesktop";
          exclude._props.title = "Vesktop";
          default-column-width.proportion = 0.5;
          default-window-height.proportion = 0.5;
          open-floating = true;
        }
      ];

      output = {
        _args = [ "eDP-1" ];
        mode = "1920x1080";
        position._props = {
          x = 0;
          y = 0;
        };
        focus-at-startup = { };
      };

      _children = [
        {
          output = {
            _args = [ "HDMI-A-1" ];
            mode = "1920x1080";
            position._props = {
              x = 0;
              y = -1080;
            };
            hot-corners.off = { };
          };
        }
        {
          window-rule = {
            match._props.app-id = "mpv";
            open-on-output = "HDMI-A-1";
          };
        }
        {
          window-rule = {
            geometry-corner-radius = 10;
            clip-to-geometry = true;
          };
        }
      ];

      layer-rule = {
        match._props.namespace = "wallpaper";
        place-within-backdrop = true;
      };

      layout = {
        gaps = 8;
        always-center-single-column = { };
        empty-workspace-above-first = { };
        background-color = "transparent";

        preset-column-widths._children = [
          { proportion = 0.5; }
          { proportion = 0.33; }
        ];

        default-column-width.proportion = 1.0;

        focus-ring = {
          width = 2;
          active-color = "#45475a";
        };

        border.off = { };

        tab-indicator = {
          hide-when-single-tab = { };
          place-within-column = { };
        };
      };

      binds = {
        # General use binds
        "Mod+Space" = {
          _props.repeat = false;
          spawn = "${lib.getExe' pkgs.tofi "tofi-drun"}";
        };

        "Mod+T" = {
          _props.repeat = false;
          spawn = "${lib.getExe pkgs.ghostty}";
        };

        "Mod+F" = {
          _props.repeat = false;
          spawn = "${lib.getExe zen-browser}";
        };

        "Mod+Shift+Delete" = {
          _props.repeat = false;
          quit = { };
        };

        "Mod+Q" = {
          _props.repeat = false;
          close-window = { };
        };

        "Mod+O" = {
          _props.repeat = false;
          toggle-overview = { };
        };

        # Screencapture
        "Mod+Print" = {
          _props.repeat = false;
          screenshot = { };
        };

        "Mod+Shift+Print" = {
          _props.repeat = false;
          screenshot-window = { };
        };

        # Window and workspace movement
        ## Move focus with Mod + [hjkl]
        "Mod+H".focus-column-left = { };
        "Mod+J".focus-window-or-workspace-down = { };
        "Mod+K".focus-window-or-workspace-up = { };
        "Mod+L".focus-column-right = { };
        "Mod+Shift+WheelScrollDown".focus-column-right = { };
        "Mod+Shift+WheelScrollUp".focus-column-left = { };
        "Mod+WheelScrollDown".focus-window-or-workspace-down = { };
        "Mod+WheelScrollUp".focus-window-or-workspace-up = { };

        ## Switch to previous / next monitor with Mod + [pn]
        "Mod+P".focus-monitor-up = { };
        "Mod+N".focus-monitor-down = { };

        ## Switch workspaces with Mod + [1-5]
        "Mod+1".focus-workspace = 1;
        "Mod+2".focus-workspace = 2;
        "Mod+3".focus-workspace = 3;
        "Mod+4".focus-workspace = 4;
        "Mod+5".focus-workspace = 5;

        ## Move focused window around or between workspaces with Mod + Shift + [hjkl]
        "Mod+Shift+H".move-column-left = { };
        "Mod+Shift+J".move-window-down-or-to-workspace-down = { };
        "Mod+Shift+K".move-window-up-or-to-workspace-up = { };
        "Mod+Shift+L".move-column-right = { };

        ## Move focused window silently to a workspace with Mod + Alt + [jk]
        "Mod+Alt+J".move-window-to-workspace-down._props.focus = false;
        "Mod+Alt+K".move-window-to-workspace-up._props.focus = false;

        ## Move current workspace to the previous / next monitor with Mod + Shift + [pn]
        "Mod+Shift+P".move-workspace-to-monitor-previous = { };
        "Mod+Shift+N".move-workspace-to-monitor-next = { };

        # Column manipulation
        ## Resize focused window / column with Mod + [Shift] + [-=]
        "Mod+Minus".set-column-width = "-10%";
        "Mod+Equal".set-column-width = "+10%";
        "Mod+Shift+Minus".set-window-height = "-10%";
        "Mod+Shift+Equal".set-window-height = "+10%";
        "Mod+E".expand-column-to-available-width = { };
        "Mod+R".switch-preset-column-width = { };
        "Mod+M".maximize-column = { };

        ## Consume right-adjacent window into current column with Mod + [,.]
        "Mod+Comma".consume-window-into-column = { };
        "Mod+Period".expel-window-from-column = { };

        ## Consume / expel current window into left / right adjacent column with Mod + Shift + [,.]
        "Mod+Shift+Comma".consume-or-expel-window-left = { };
        "Mod+Shift+Period".consume-or-expel-window-right = { };

        ## Toggle between tabbed and column display with Mod + ;
        "Mod+SemiColon".toggle-column-tabbed-display = { };

        # Media controls
        "XF86AudioRaiseVolume" = {
          _props.allow-when-locked = true;
          spawn = [
            "${lib.getExe' pkgs.wireplumber "wpctl"}"
            "set-volume"
            "@DEFAULT_SINK@"
            "5%+"
            "--limit"
            "0.5"
          ];
        };

        "XF86AudioLowerVolume" = {
          _props.allow-when-locked = true;
          spawn = [
            "${lib.getExe' pkgs.wireplumber "wpctl"}"
            "set-volume"
            "@DEFAULT_SINK@"
            "5%-"
          ];
        };

        "XF86AudioMute" = {
          _props.allow-when-locked = true;
          spawn = [
            "${lib.getExe' pkgs.wireplumber "wpctl"}"
            "set-mute"
            "@DEFAULT_SINK@"
            "toggle"
          ];
        };

        "Shift+XF86AudioRaiseVolume" = {
          _props.allow-when-locked = true;
          spawn = [
            "${lib.getExe' pkgs.wireplumber "wpctl"}"
            "set-volume"
            "@DEFAULT_SOURCE@"
            "5%+"
            "--limit"
            "1.0"
          ];
        };

        "Shift+XF86AudioLowerVolume" = {
          _props.allow-when-locked = true;
          spawn = [
            "${lib.getExe' pkgs.wireplumber "wpctl"}"
            "set-volume"
            "@DEFAULT_SOURCE@"
            "5%-"
          ];
        };

        "Shift+XF86AudioMute" = {
          _props.allow-when-locked = true;
          spawn = [
            "${lib.getExe' pkgs.wireplumber "wpctl"}"
            "set-mute"
            "@DEFAULT_SOURCE@"
            "toggle"
          ];
        };

        "XF86AudioPlay" = {
          _props.allow-when-locked = true;
          spawn = [
            "${lib.getExe pkgs.playerctl}"
            "play-pause"
          ];
        };

        "XF86AudioStop" = {
          _props.allow-when-locked = true;
          spawn = [
            "${lib.getExe pkgs.playerctl}"
            "stop"
          ];
        };

        "XF86AudioPrev" = {
          _props.allow-when-locked = true;
          spawn = [
            "${lib.getExe pkgs.playerctl}"
            "previous"
          ];
        };

        "XF86AudioNext" = {
          _props.allow-when-locked = true;
          spawn = [
            "${lib.getExe pkgs.playerctl}"
            "next"
          ];
        };
      };
    };
  };
}
