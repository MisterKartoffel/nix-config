{
  fileSystems."/nix".neededForBoot = true;

  disko.devices.nodev = {
    "/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=10%"
        "mode=755"
      ];
    };
  };

  disko.devices.disk.main = {
    device = "/dev/disk/by-uuid/c699d00f-fc62-436d-b9c5-0d6125be10f1";
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
        extraArgs = [ "-f" ];

        subvolumes = {
          "/persist" = {
            mountpoint = "/persist";
            mountOptions = [
              "subvol=persist"
              "noatime"
              "compress=zstd"
              "defaults"
            ];
          };
          "/nix" = {
            mountpoint = "/nix";
            mountOptions = [
              "subvol=nix"
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
