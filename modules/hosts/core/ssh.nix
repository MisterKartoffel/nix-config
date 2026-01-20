{ config, ... }:
{
  services.openssh = {
    enable = true;

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  networking.firewall.allowedTCPPorts = config.services.openssh.ports;
  programs.ssh.startAgent = config.services.openssh.enable;
}
