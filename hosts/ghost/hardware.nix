{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  environment.systemPackages = with pkgs; [
    exfatprogs
    mesa
  ];

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

  nixpkgs.hostPlatform = config.modules.system.architecture;
  system.stateVersion = config.modules.system.stateVersion;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-vaapi-driver
        vpl-gpu-rt
      ];
    };

    amdgpu.legacySupport.enable = true;
    enableRedistributableFirmware = true;
  };

  services.xserver.videoDrivers = [ "modesetting" ];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "i915";
  };

  boot.kernelModules = [
    "kvm-intel"
    "i915"
  ];
}
