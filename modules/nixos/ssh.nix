{ config, lib, ... }:
let
  cfg = config.modules.services.sops;
in
{
  config = lib.mkIf cfg.enable {
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
