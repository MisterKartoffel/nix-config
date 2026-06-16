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

      knownHosts."github.com".publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";

      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    programs.ssh.startAgent = !gnome-keyring.enable;
  };
}
