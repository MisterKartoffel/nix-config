{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.networking) hostName;
  inherit (config.services) qbittorrent;
  inherit (config.sops) secrets;
  inherit (config) preservation;

  baseCommand = "${lib.getExe pkgs.btrfs-progs} subvolume";
  snapshotPath = "/persist/.snapshot";
in
{
  services.restic.backups.impermanence = lib.mkIf preservation.enable {
    initialize = true;
    inhibitsSleep = true;

    repository = "rclone:mega:restic/${hostName}";
    passwordFile = secrets."restic/password".path;
    rcloneConfigFile = secrets."rclone/config".path;

    paths = [ snapshotPath ];
    exclude = lib.optionals qbittorrent.enable [ "qBittorrent/Torrents" ];

    backupPrepareCommand = baseCommand + " snapshot -r /persist " + snapshotPath;
    backupCleanupCommand = baseCommand + " delete " + snapshotPath;

    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "30m";
    };

    pruneOpts = [
      "--keep-daily 1"
      "--keep-weekly 1"
      "--keep-monthly 1"
    ];
  };
}
