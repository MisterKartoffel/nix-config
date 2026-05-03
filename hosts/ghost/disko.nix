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
                        mountpoint = "/";
                        mountOptions = [ "noatime" "compress=zstd" "defaults" ];
                        subvolumes = {
                            "/rootfs".mountpoint = "/rootfs";
                            "/rootfs/home" = { };
                            "/nix".mountpoint = "/nix";
                            "/swap" = {
                                mountpoint = "/.swap";
                                swap.swapfile = {
                                    size = "8G";
                                    path = "swapfile";
                                };
                            };
                        };
                    };
                };
            };
        };
    };
}
