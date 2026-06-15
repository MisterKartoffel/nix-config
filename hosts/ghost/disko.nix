{ config, ... }:
let
  inherit (config.modules.services) impermanence;
in
{
  fileSystems.${impermanence.path}.neededForBoot = true;

  disko.devices.nodev."/" = {
    fsType = "tmpfs";
    mountOptions = [
      "size=256M"
      "mode=755"
    ];
  };

  disko.devices.disk.main = {
    device = "/dev/disk/by-id/ata-ST1000DM003-1CH162_S1DJFRC0";
    type = "disk";

    content.type = "gpt";

    content.partitions.ESP = {
      size = "512M";
      type = "EF00";

      content = {
        type = "filesystem";
        format = "vfat";
        mountpoint = "/boot";
        mountOptions = [ "umask=0077" ];
      };
    };

    content.partitions.root = {
      size = "100%";

      content = {
        type = "btrfs";
        extraArgs = [ "-L NixOS -f" ];

        subvolumes = {
          ${impermanence.path} = {
            mountpoint = impermanence.path;
            mountOptions = [
              "noatime"
              "compress=zstd"
              "defaults"
            ];
          };
          "/nix" = {
            mountpoint = "/nix";
            mountOptions = [
              "noatime"
              "compress=zstd"
              "defaults"
            ];
          };
        };
      };
    };
  };
}
