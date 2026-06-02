{ config, lib, ... }:
let
  inherit (config.modules.services) impermanence sops;
  inherit (config.services.gnome) gnome-keyring;
in
{
  config = lib.mkIf sops.enable {
    services.openssh = {
      enable = true;
      generateHostKeys = !impermanence.enable;

      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    programs.ssh.startAgent = !gnome-keyring.enable;
  };
}
