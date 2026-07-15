{ config, lib, ... }:
let
  inherit (config.modules.services) sops;
  inherit (config.sops) secrets;
in
{
  services.openssh = {
    generateHostKeys = !sops.enable;
    hostKeys = lib.optionals sops.enable [
      {
        path = secrets."ssh_key".path;
        type = "ed25519";
      }
    ];

    knownHosts."github.com".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
}
