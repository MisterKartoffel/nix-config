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
in
{
  environment.systemPackages = builtins.attrValues { inherit (pkgs) rclone restic; };

  services.restic.backups.impermanence = lib.mkIf impermanence.enable {
    initialize = true;

    repository = "rclone:mega:restic/${hostName}";
    passwordFile = secrets.restic.password.path;
    rcloneConfigFile = secrets.rclone.config.path;

    paths = [ snapshotPath ];
    exclude = lib.optionals qbittorrent.enable [ "qBittorrent" ];

    backupPrepareCommand = ''
      ${lib.getExe' pkgs.btrfs-progs "btrfs"} subvolume snapshot -r ${impermanence.path} ${snapshotPath}
    '';

    backupCleanupCommand = ''
      ${lib.getExe' pkgs.btrfs-progs "btrfs"} subvolume delete ${snapshotPath}
    '';

    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };

    pruneOpts = [
      "--keep-daily 1"
      "--keep-weekly 1"
      "--keep-monthly 1"
    ];
  };
}
