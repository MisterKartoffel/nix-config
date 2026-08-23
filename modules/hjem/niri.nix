{
  self,
  osConfig,
  pkgs,
  lib,
  ...
}:
let
  inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) zen-browser;
  inherit (osConfig.programs) niri;
in
{
  xdg.config.files."niri/config.kdl" = {
    inherit (niri) enable;

    source = pkgs.writeTextFile {
      name = "niri-config.kdl";
      checkPhase = "${lib.getExe pkgs.niri} validate -c $out";
      text = /* kdl */ ''
        prefer-no-csd
        screenshot-path null

        clipboard { disable-primary; }
        recent-windows { off; }

        hotkey-overlay {
          skip-at-startup
          hide-not-bound
        }

        input {
          disable-power-key-handling
          focus-follows-mouse max-scroll-amount="0%"

          keyboard {
            numlock
            xkb {
              layout "br"
              options "caps:escape_shifted_capslock"
            }
          }
        }

        window-rule {
          match title="Picture-in-Picture"
          match app-id="xdg-desktop-portal-gtk"
          match app-id="vesktop"
          exclude title="Vesktop"

          default-column-width { proportion 0.5; }
          default-window-height { proportion 0.5; }
          open-floating true
        }

        window-rule {
          match app-id="mpv"
          open-on-output "HDMI-A-1"
        }

        window-rule {
          geometry-corner-radius 10
          clip-to-geometry true
        }

        layer-rule {
          match namespace="wallpaper"
          place-within-backdrop true
        }

        output "eDP-1" {
          focus-at-startup
          mode "1920x1080"
          position x=0 y=0
        }

        output "HDMI-A-1" {
          hot-corners { off; }
          mode "1920x1080"
          position x=0 y=-1080
        }

        layout {
          gaps 8
          always-center-single-column
          empty-workspace-above-first
          background-color "transparent"

          default-column-width { proportion 1.0; }

          preset-column-widths {
            proportion 0.5
            proportion 0.33
          }

          focus-ring {
            active-color "#45475a"
            width 2
          }

          border { off; }

          tab-indicator {
            hide-when-single-tab
            place-within-column
          }
        }

        cursor {
          xcursor-theme "Bibata-Modern-Ice"
          xcursor-size 24
          hide-after-inactive-ms 1000
          hide-when-typing
        }

        binds {
          // General use binds
          Mod+Space repeat=false { spawn "${lib.getExe' pkgs.tofi "tofi-drun"}"; }
          Mod+T repeat=false { spawn "${lib.getExe pkgs.ghostty}"; }
          Mod+F repeat=false { spawn "${lib.getExe zen-browser}"; }

          Mod+Shift+Delete { quit; }
          Mod+Q { close-window; }
          Mod+O { toggle-overview; }

          // Screencapture
          Mod+Print { screenshot; }
          Mod+Shift+Print { screenshot-window; }
          Mod+A { spawn "${lib.getExe pkgs.vellum}" "toggle"; }

          // Window and workspace movement
            // Switch workspaces with Mod + [1-9]
              Mod+1 { focus-workspace 1; }
              Mod+2 { focus-workspace 2; }
              Mod+3 { focus-workspace 3; }
              Mod+4 { focus-workspace 4; }
              Mod+5 { focus-workspace 5; }
              Mod+6 { focus-workspace 6; }
              Mod+7 { focus-workspace 7; }
              Mod+8 { focus-workspace 8; }
              Mod+9 { focus-workspace 9; }

            // Move focus with Mod + [hjkl]
              Mod+H { focus-column-left; }
              Mod+J { focus-window-or-workspace-down; }
              Mod+K { focus-window-or-workspace-up; }
              Mod+L { focus-column-right; }

            // Switch to previous / next monitor with Mod + [pn]
              Mod+P { focus-monitor-up; }
              Mod+N { focus-monitor-down; }

            // Move focused window / column in / between workspaces with Mod + Shift + [hjkl]
              Mod+Shift+H { move-column-left; }
              Mod+Shift+J { move-window-down-or-to-workspace-down; }
              Mod+Shift+K { move-window-up-or-to-workspace-up; }
              Mod+Shift+L { move-column-right; }

            // Move current workspace to the previous / next monitor with Mod + Shift + [pn]
              Mod+Shift+P { move-workspace-to-monitor-previous; }
              Mod+Shift+N { move-workspace-to-monitor-next; }

          // Column manipuation
            // Resize focused window / column
              Mod+Minus { set-column-width "-10%"; }
              Mod+Equal { set-column-width "+10%"; }
              Mod+E { expand-column-to-available-width; }
              Mod+R { switch-preset-column-width; }
              Mod+M { maximize-column; }

            // Consume right-adjacent window into current column with Mod + [,.]
              Mod+Comma { consume-window-into-column; }
              Mod+Period { expel-window-from-column; }

            // Consume / expel current window into left- / right-adjacent column with Mod + Shift + [,.]
              Mod+Shift+Comma { consume-or-expel-window-left; }
              Mod+Shift+Period { consume-or-expel-window-right; }

            // Toggle between tabbed and column display with Mod + ;
              Mod+SemiColon { toggle-column-tabbed-display; }

          // Media controls
            XF86AudioRaiseVolume allow-when-locked=true { spawn "${lib.getExe' pkgs.wireplumber "wpctl"}" "set-volume" "@DEFAULT_SINK@" "5%+" "--limit" "0.5"; }
            XF86AudioLowerVolume allow-when-locked=true { spawn "${lib.getExe' pkgs.wireplumber "wpctl"}" "set-volume" "@DEFAULT_SINK@" "5%-"; }
            XF86AudioMute allow-when-locked=true { spawn "${lib.getExe' pkgs.wireplumber "wpctl"}" "set-mute" "@DEFAULT_SINK@" "toggle"; }
            Shift+XF86AudioRaiseVolume allow-when-locked=true { spawn "${lib.getExe' pkgs.wireplumber "wpctl"}" "set-volume" "@DEFAULT_SOURCE@" "5%+" "--limit" "1.0"; }
            Shift+XF86AudioLowerVolume allow-when-locked=true { spawn "${lib.getExe' pkgs.wireplumber "wpctl"}" "set-volume" "@DEFAULT_SOURCE@" "5%-"; }
            Shift+XF86AudioMute allow-when-locked=true { spawn "${lib.getExe' pkgs.wireplumber "wpctl"}" "set-mute" "@DEFAULT_SOURCE@" "toggle"; }

            XF86AudioPlay allow-when-locked=true { spawn "${lib.getExe pkgs.playerctl}" "play-pause"; }
            XF86AudioStop allow-when-locked=true { spawn "${lib.getExe pkgs.playerctl}" "stop"; }
            XF86AudioPrev allow-when-locked=true { spawn "${lib.getExe pkgs.playerctl}" "previous"; }
            XF86AudioNext allow-when-locked=true { spawn "${lib.getExe pkgs.playerctl}" "next"; }
        }
      '';
    };
  };
}
