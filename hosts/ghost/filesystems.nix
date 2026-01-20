{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ exfatprogs ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/4c5031cd-4a94-4f3c-926d-035a96d1e55a";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/935C-0287";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [ ];
}
