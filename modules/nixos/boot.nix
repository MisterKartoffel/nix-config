{ config, lib, ... }:
let
  inherit (config.programs) niri;
in
{
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
      consoleMode = "auto";
    };

    efi.canTouchEfiVariables = true;
  };

  services.getty = {
    autologinUser =
      let
        inherit (config.modules.system) users;
      in
      lib.findFirst (username: users.${username}.autologin) null (builtins.attrNames users);
    autologinOnce = true;
  };

  environment.loginShellInit = lib.optional niri.enable ''
    if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    	exec niri-session -l
    fi
  '';
}
