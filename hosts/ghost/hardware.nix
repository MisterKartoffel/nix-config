{ config, lib, modulesPath, pkgs, ... }: {
	imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

	nixpkgs.hostPlatform = config.hostSpec.systemArch;
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

	services = {
		xserver.videoDrivers = [ "modesetting" ];
		pulseaudio.enable = lib.mkForce false;

		pipewire = {
			enable = true;
			pulse.enable = true;
			jack.enable = true;
			alsa.enable = true;
			wireplumber.enable = true;
		};
	};

	environment.sessionVariables = {
		LIBVA_DRIVER_NAME = "i915";
	};
}
