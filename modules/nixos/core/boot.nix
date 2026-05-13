{ config, ... }:
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
    autologinUser = (builtins.head config.modules.system.users).name;
    autologinOnce = true;
  };
}
