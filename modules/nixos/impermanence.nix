{ config, lib, ... }:
let
  inherit (config.modules.services) impermanence sops;
  inherit (config.services) qbittorrent;
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
    ]
    ++ lib.optionals qbittorrent.enable [
      {
        directory = "${qbittorrent.profileDir}/qBittorrent";
        inherit (qbittorrent) user group;
      }
    ];

    files = lib.optionals sops.enable [
      {
        file = "/var/lib/sops-nix/key.txt";
        parentDirectory.mode = "0700";
      }
    ];
  };
}
