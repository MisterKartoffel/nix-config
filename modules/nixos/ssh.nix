{ config, lib, ... }:
let
  inherit (config.modules.services) sops;
in
{
  config = lib.mkIf sops.enable {
    services.openssh = {
      enable = true;

      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    programs.ssh.startAgent = true;
  };
}
