{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.programs) niri;
in
{
  config = lib.mkIf niri.enable {
    programs.niri.useNautilus = false;

    xdg.portal = {
      xdgOpenUsePortal = true;
      extraPortals = builtins.attrValues { inherit (pkgs) xdg-desktop-portal-gtk; };
    };

    environment.loginShellInit = lib.optionalString niri.enable ''
      if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
      	exec niri-session -l
      fi
    '';
  };
}
