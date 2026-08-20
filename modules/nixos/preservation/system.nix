{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (config.modules.services) sops;
  inherit (config.networking.wireless) iwd;
  inherit (config.services) qbittorrent;
in
{
  imports = [ inputs.preservation.nixosModules.default ];

  preservation.preserveAt."/persist" = {
    commonMountOptions = [
      "x-gvfs-hide"
      "x-gdu.hide"
    ];

    directories = [
      {
        directory = "/var/lib/nixos";
        inInitrd = true;
      }
      "/var/lib/systemd/timers"
      "/var/lib/systemd/rfkill"
      "/var/log"
    ]
    ++ lib.optionals iwd.enable [ "/var/lib/iwd" ]
    ++ lib.optionals qbittorrent.enable [
      {
        directory = "${qbittorrent.profileDir}/qBittorrent";
        inherit (qbittorrent) user group;
      }
    ];

    files = lib.optionals sops.enable [
      {
        file = config.sops.age.keyFile;
        inInitrd = true;
        configureParent = true;
        parent.mode = "0700";
      }
    ];
  };
}
