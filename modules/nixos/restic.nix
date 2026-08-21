{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.networking) hostName;
  inherit (config.services) qbittorrent;
  inherit (config.sops) secrets templates;
  inherit (config) preservation;
in
{
  services.restic.backups.impermanence = lib.mkIf preservation.enable {
    initialize = true;
    inhibitsSleep = true;

    repository = "rclone:mega:restic/${hostName}";
    passwordFile = secrets."restic/password".path;
    rcloneConfigFile = templates."restic-rclone.ini".path;

    paths = [ "/persist/.snapshot" ];
    exclude = lib.optionals qbittorrent.enable [ "qBittorrent/Torrents" ];

    backupPrepareCommand = "${lib.getExe pkgs.btrfs-progs} subvolume snapshot -r /persist /persist/.snapshot";
    backupCleanupCommand = "${lib.getExe pkgs.btrfs-progs} subvolume delete /persist/.snapshot";

    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "30m";
    };

    pruneOpts = [
      "--keep-daily 1"
      "--keep-monthly 3"
    ];
  };
}
