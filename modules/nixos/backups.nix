{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.modules.services) impermanence;
  inherit (config.modules) secrets;
  inherit (config.networking) hostName;
  inherit (config.services) qbittorrent;

  snapshotPath = "${impermanence.path}/.snapshot";
  baseCommand = "${lib.getExe pkgs.btrfs-progs} subvolume";
in
{
  environment.systemPackages = builtins.attrValues { inherit (pkgs) rclone restic; };

  services.restic.backups.impermanence = lib.mkIf impermanence.enable {
    initialize = true;

    repository = "rclone:mega:restic/${hostName}";
    passwordFile = secrets.restic.password.path;
    rcloneConfigFile = secrets.rclone.config.path;

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
