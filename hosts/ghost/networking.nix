{ config, ... }: {
	networking = {
		hostName = config.hostSpec.hostname;
		nameservers = [ "1.1.1.1" "8.8.8.8" ];
		networkmanager.enable = true;
	};

	services.resolved.enable = true;
}
