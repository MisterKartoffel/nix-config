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

    networking.firewall.allowedTCPPorts = config.services.openssh.ports;
    programs.ssh.startAgent = true;
  };
}
