{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (osConfig.programs) niri;

  zen-browser = config.programs.zen-browser.package;
  toKDL = lib.hm.generators.toKDL { };
in
{
  xdg.configFile."niri/config.kdl".source = lib.mkIf niri.enable (
    pkgs.writeTextFile {
      name = "config.kdl";
      checkPhase = "${lib.getExe pkgs.niri} validate -c $out";
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

        binds =
          lib.mapAttrs (_: value: { _props.repeat = false; } // value) {
            # General use binds
            "Mod+Space".spawn = "${lib.getExe' pkgs.tofi "tofi-drun"}";
            "Mod+T".spawn = "${lib.getExe pkgs.ghostty}";
            "Mod+F".spawn = "${lib.getExe zen-browser}";

            "Mod+Shift+Delete".quit = { };
            "Mod+Q".close-window = { };
            "Mod+O".toggle-overview = { };

            # Screencapture
            "Mod+Print".screenshot = { };
            "Mod+Shift+Print".screenshot-window = { };
          }

          # Window and workspace movement
          ## Switch workspaces with Mod + [1-5]
          // builtins.listToAttrs (
            map (n: {
              name = "Mod+${toString n}";
              value.focus-workspace = n;
            }) (lib.range 1 9)
          )
          // {
            ## Move focus with Mod + [hjkl]
            "Mod+H".focus-column-left = { };
            "Mod+J".focus-window-or-workspace-down = { };
            "Mod+K".focus-window-or-workspace-up = { };
            "Mod+L".focus-column-right = { };

            ## Switch to previous / next monitor with Mod + [pn]
            "Mod+P".focus-monitor-up = { };
            "Mod+N".focus-monitor-down = { };

            ## Move focused window around or between workspaces with Mod + Shift + [hjkl]
            "Mod+Shift+H".move-column-left = { };
            "Mod+Shift+J".move-window-down-or-to-workspace-down = { };
            "Mod+Shift+K".move-window-up-or-to-workspace-up = { };
            "Mod+Shift+L".move-column-right = { };

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
          }

          # Media controls
          // lib.mapAttrs (_: value: { _props.allow-when-locked = true; } // value) {
            "XF86AudioRaiseVolume" = {
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
              spawn = [
                "${lib.getExe' pkgs.wireplumber "wpctl"}"
                "set-volume"
                "@DEFAULT_SINK@"
                "5%-"
              ];
            };

            "XF86AudioMute" = {
              spawn = [
                "${lib.getExe' pkgs.wireplumber "wpctl"}"
                "set-mute"
                "@DEFAULT_SINK@"
                "toggle"
              ];
            };

            "Shift+XF86AudioRaiseVolume" = {
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
              spawn = [
                "${lib.getExe' pkgs.wireplumber "wpctl"}"
                "set-volume"
                "@DEFAULT_SOURCE@"
                "5%-"
              ];
            };

            "Shift+XF86AudioMute" = {
              spawn = [
                "${lib.getExe' pkgs.wireplumber "wpctl"}"
                "set-mute"
                "@DEFAULT_SOURCE@"
                "toggle"
              ];
            };

            "XF86AudioPlay" = {
              spawn = [
                "${lib.getExe pkgs.playerctl}"
                "play-pause"
              ];
            };

            "XF86AudioStop" = {
              spawn = [
                "${lib.getExe pkgs.playerctl}"
                "stop"
              ];
            };

            "XF86AudioPrev" = {
              spawn = [
                "${lib.getExe pkgs.playerctl}"
                "previous"
              ];
            };

            "XF86AudioNext" = {
              spawn = [
                "${lib.getExe pkgs.playerctl}"
                "next"
              ];
            };
          };
      };
    }
  );
}
