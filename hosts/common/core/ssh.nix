{ config, lib, ... }:
let
  inherit (lib) mkIf;
  cfg = config.modules.services.ssh;
in
{
  config = mkIf cfg.enable {
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
