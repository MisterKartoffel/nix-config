{
  config,
  lib,
  ...
}:
let
  inherit (config.programs) niri;
in
{
  config = lib.mkIf niri.enable {
    programs.niri.useNautilus = false;
    xdg.portal.xdgOpenUsePortal = true;

    environment.loginShellInit = ''
      if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
      	exec niri-session -l
      fi
    '';
  };
}
