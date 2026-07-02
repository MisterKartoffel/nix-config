{ config, ... }:
let
  inherit (config.modules.services) impermanence;
  inherit (config.services.gnome) gnome-keyring;
  inherit (config.modules.services) sops;
in
{
  services.openssh = {
    generateHostKeys = !sops.enable;

    knownHosts."github.com".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  programs.ssh.startAgent = !gnome-keyring.enable;
}
