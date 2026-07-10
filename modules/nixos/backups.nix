{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.modules.services) impermanence;
  inherit (config.networking) hostName;
  inherit (config.services) qbittorrent;
  inherit (config.sops) secrets;

  baseCommand = "${lib.getExe pkgs.btrfs-progs} subvolume";
  snapshotPath = "${impermanence.path}/.snapshot";
in
{
  services.restic.backups.impermanence = lib.mkIf impermanence.enable {
    initialize = true;
    inhibitsSleep = true;

    repository = "rclone:mega:restic/${hostName}";
    passwordFile = secrets."restic/password".path;
    rcloneConfigFile = secrets."rclone/config".path;

    paths = [ snapshotPath ];
    exclude = lib.optionals qbittorrent.enable [ "qBittorrent/Torrents" ];

    backupPrepareCommand = baseCommand + " snapshot -r ${impermanence.path} " + snapshotPath;
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
