{ pkgs, ... }: {
	home.packages = with pkgs; [ niri ];

	xdg.portal = {
		enable = true;
		config.niri.default = "gnome;gtk";
		extraPortals = [
			pkgs.xdg-desktop-portal-gnome
			pkgs.xdg-desktop-portal-gtk
		];
	};

	xdg.configFile."niri/config.kdl".text =
		''
			prefer-no-csd
			screenshot-path "/tmp/niri-screenshot.png"
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

			output "eDP-1" {
				mode "1920x1080"
				position x=0 y=0
				focus-at-startup
			}

			output "HDMI-A-1" {
				mode "1920x1080"
				position x=0 y=-1080
				hot-corners { off; }
			}

			layout {
				gaps 8
				always-center-single-column
				empty-workspace-above-first
				background-color "transparent"

				preset-column-widths {
					proportion 0.5
					proportion 0.33
				}

				default-column-width { proportion 1.0; }

				focus-ring {
					width 2
					active-color "#45475a"
				}

				border { off; };

				tab-indicator {
					hide-when-single-tab
					place-within-column
				}
			}

			window-rule {
				match title=r#"^Picture-in-Picture$"# app-id=r#"^zen-beta$"#
				match app-id=r#"^vesktop$"#
				exclude title=r#"^Vesktop$"#

				default-column-width { proportion 0.5; }
				default-window-height { proportion 0.5; }
				open-floating true
			}

			window-rule {
				match app-id=r#"^mpv$"#

				open-on-output "HDMI-A-1"
			}

			window-rule {
				geometry-corner-radius 10
				clip-to-geometry true
			}

			layer-rule {
				match namespace=r#"^wallpaper$"#
				place-within-backdrop true
			}

			binds {
				// General use binds
					Mod+Shift+Slash  repeat=false { show-hotkey-overlay; }
					Mod+T            repeat=false { spawn "ghostty" "+new-window"; }
					Mod+F            repeat=false { spawn "zen"; }
					Mod+Space        repeat=false { spawn "fuzzel"; }
					Mod+Shift+Delete repeat=false { quit; }
					Mod+Q            repeat=false { close-window; }
					Mod+O            repeat=false { toggle-overview; }

				// Screencapture
					Mod+Print        repeat=false { screenshot; }
					Mod+Shift+Print  repeat=false { screenshot-window; }

				// Window and workspace movement
					// Move focus with Mod + [hjkl]
						Mod+H { focus-column-left; }
						Mod+J { focus-window-or-workspace-down; }
						Mod+K { focus-window-or-workspace-up; }
						Mod+L { focus-column-right; }

					// Move focus right / left with Mod + Shift + Mouse Wheel
						Mod+Shift+WheelScrollDown { focus-column-right; }
						Mod+Shift+WheelScrollUp { focus-column-left; }

						// Focus window or workspace below / above with Mod + Mouse Wheel
							Mod+WheelScrollDown { focus-window-or-workspace-down; }
							Mod+WheelScrollUp { focus-window-or-workspace-up; }

					// Switch to previous / next monitor with Mod + [pn]
						Mod+P { focus-monitor-up; }
						Mod+N { focus-monitor-down; }

					// Switch workspaces with Mod + [1-5]
						Mod+1 { focus-workspace 1; }
						Mod+2 { focus-workspace 2; }
						Mod+3 { focus-workspace 3; }
						Mod+4 { focus-workspace 4; }
						Mod+5 { focus-workspace 5; }

					// Move focused window around or between workspaces with Mod + Shift + [hjkl]
						Mod+Shift+H { move-column-left; }
						Mod+Shift+J { move-window-down-or-to-workspace-down; }
						Mod+Shift+K { move-window-up-or-to-workspace-up; }
						Mod+Shift+L { move-column-right; }

					// Move focused window silently to a workspace with Mod + Alt + [jk]
						Mod+Alt+J { move-window-to-workspace-down focus=false; }
						Mod+Alt+K { move-window-to-workspace-up focus=false; }

					// Move current workspace to the previous / next monitor with Mod + Shift + [pn]
						Mod+Shift+P { move-workspace-to-monitor-previous; }
						Mod+Shift+N { move-workspace-to-monitor-next; }

				// Column manipulation
					// Resize focused window / column with Mod + [Shift] + [-=]
						Mod+Minus { set-column-width "-10%"; }
						Mod+Equal { set-column-width "+10%"; }
						Mod+Shift+Minus { set-window-height "-10%"; }
						Mod+Shift+Equal { set-window-height "+10%"; }
						Mod+E { expand-column-to-available-width; }
						Mod+R { switch-preset-column-width; }
						Mod+M { maximize-column; }

					// Consume right-adjacent window into current column with Mod + [,.]
						Mod+Comma { consume-window-into-column; }
						Mod+Period { expel-window-from-column; }

					// Consume / expel current window into left / right adjacent column with Mod + Shift + [,.]
						Mod+Shift+Comma { consume-or-expel-window-left; }
						Mod+Shift+Period { consume-or-expel-window-right; }

					// Toggle between tabbed and column display with Mod + ;
						Mod+SemiColon { toggle-column-tabbed-display; }

				// Media controls
					XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_SINK@" "5%+" "--limit" "0.5"; }
					XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_SINK@" "5%-"; }
					XF86AudioMute        allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_SINK@" "toggle"; }
					Shift+XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_SOURCE@" "5%+" "--limit" "1.0"; }
					Shift+XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_SOURCE@" "5%-"; }
					Shift+XF86AudioMute        allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_SOURCE@" "toggle"; }
					XF86AudioPlay allow-when-locked=true { spawn "playerctl" "play-pause"; }
					XF86AudioStop allow-when-locked=true { spawn "playerctl" "stop"; }
					XF86AudioPrev allow-when-locked=true { spawn "playerctl" "previous"; }
					XF86AudioNext allow-when-locked=true { spawn "playerctl" "next"; }
			}
		'';
}
