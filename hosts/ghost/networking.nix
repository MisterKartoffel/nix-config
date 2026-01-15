{ config, ... }: {
	systemd.network = let
		ethernet = "enp7s0";
		wireless = "wlp9s0";
		bond = "bond0";
	in {
		enable = true;

		netdevs = {
			"10-${bond}" = {
				netdevConfig = {
					Kind = "bond";
					Name = bond;
				};
				bondConfig = {
					Mode = "active-backup";
					PrimaryReselectPolicy = "always";
					MIIMonitorSec = "1s";
					FailOverMACPolicy = "active";
				};
			};
		};

		networks = {
			"30-${ethernet}" = {
				matchConfig.Name = ethernet;
				networkConfig = {
					Bond = bond;
					PrimarySlave = true;
				};
			};

			"30-${wireless}" = {
				matchConfig.Name = wireless;
				networkConfig.Bond = bond;
			};

			"40-${bond}" = {
				matchConfig.Name = bond;
				linkConfig.RequiredForOnline = "yes";
				networkConfig = {
					BindCarrier = "${ethernet} ${wireless}";
					DHCP = "yes";
				};
			};
		};
	};

	networking = {
		wireless = {
			enable = true;
			secretsFile = "/run/secrets/wireless";

			networks.home = {
				SSID = "JOSÉ LUIS OI FIBRA";
				pskRaw = "ext:home";
			};
		};


		hostName = config.hostSpec.hostname;
		nameservers = [
			"1.1.1.2#security.cloudflare-dns.com"
			"2606:4700:4700::1112#security.cloudflare-dns.com"
			"9.9.9.9#tls://dns.quad9.net"
			"2620:fe::fe#tls://dns.quad9.net"
		];

		useNetworkd = true;
		useDHCP = false;
		dhcpcd.enable = false;
	};

	services.resolved = {
		enable = true;

		# Jesus, why do these have to be strings
		dnssec = "true";
		dnsovertls = "true";
		llmnr = "false";
	};
}
