{ config, lib, pkgs, modulesPath, ... }: {
	imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

	nixpkgs.hostPlatform = config.hostSpec.system;
	hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
	environment.systemPackages = with pkgs; [ mesa ];

	hardware = {
		graphics = {
			enable = true;
			extraPackages = with pkgs; [
				# intel-media-sdk
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
}
