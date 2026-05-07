{
  disko.devices.disk."/dev/sda" = {
    type = "disk";
    device = "/dev/sda";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "512M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        root = {
          size = "100%";
          type = "8304";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ];
            subvolumes = {
              "/root" = {
                mountpoint = "/";
                mountOptions = [
                  "subvol=root"
                  "noatime"
                  "compress=zstd"
                  "defaults"
                ];
              };
              "/home" = {
                mountpoint = "/home";
                mountOptions = [
                  "subvol=home"
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
              "/log" = {
                mountpoint = "/var/log";
                mountOptions = [
                  "subvol=log"
                  "noatime"
                  "compress=zstd"
                  "defaults"
                ];
              };
              "/swap" = {
                mountpoint = "/.swap";
                swap.swapfile.size = "8G";
              };
            };
          };
        };
      };
    };
  };
}
