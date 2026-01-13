{ config, ... }: {
	boot.loader = {
		systemd-boot = {
			enable = true;
			configurationLimit = 10;
			consoleMode = "auto";
		};

		efi.canTouchEfiVariables = true;
	};

	services.xserver.displayManager.lightdm.enable = false;
	services.getty = {
		autologinUser = (builtins.head config.hostSpec.userList).name;
		autologinOnce = true;
	};

	boot.kernelModules = [ "kvm-intel" "i915" ];
}
