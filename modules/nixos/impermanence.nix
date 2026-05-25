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
      {
        directory = "/etc/nixos";
        user = "mimikyu";
        group = "users";
      }
    ];

    files = [
      "/etc/machine-id"
    ]
    ++ lib.optionals sops.enable [
      {
        file = "/var/lib/sops-nix/key.txt";
        parentDirectory.mode = "0700";
      }
    ];
  };
}
