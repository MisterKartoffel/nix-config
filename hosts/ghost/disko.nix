{ inputs, ... }: {
  imports = [ inputs.disko.nixosModules.default ];

  fileSystems."/persist".neededForBoot = true;
  boot.tmp.useTmpfs = true;

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
          "/persist" = {
            mountpoint = "/persist";
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
          "/swap" = {
            mountpoint = "/swap";
            mountOptions = [
              "noatime"
              "nodatacow"
              "compress=no"
            ];
            swap.swapfile.size = "8G";
          };
        };
      };
    };
  };
}
