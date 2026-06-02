{ config, lib, ... }:
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
}
