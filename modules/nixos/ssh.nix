{ config, lib, ... }:
let
  inherit (config.modules.services) sops;
  persistence = config.environment.persistence."/persist";
in
{
  config = lib.mkIf sops.enable {
    services.openssh = {
      enable = true;
      generateHostKeys = !persistence.enable;

      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    programs.ssh.startAgent = true;
  };
}
