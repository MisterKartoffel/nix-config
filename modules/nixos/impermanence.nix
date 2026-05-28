{ config, lib, ... }:
let
  inherit (config.modules.services) impermanence sops;
in
{
  environment.persistence.${impermanence.path} = {
    inherit (impermanence) enable;
    hideMounts = true;

    directories = [
      "/var/lib/nixos"
      "/var/lib/systemd/timers"
      "/var/lib/systemd/rfkill"
      "/var/lib/systemd/coredump"
      "/var/log"
    ];

    files = lib.optionals sops.enable [
      {
        file = "/var/lib/sops-nix/key.txt";
        parentDirectory.mode = "0700";
      }
    ];
  };
}
