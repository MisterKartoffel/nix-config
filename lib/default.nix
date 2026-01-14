{ lib, ... }: {
	makeSystemUser = { user, config }: {
		inherit (user) name;
		value = {
			inherit (user) description shell extraGroups;
			hashedPasswordFile = config.sops.secrets."${user.name}/password".path;
			isNormalUser = true;
		};
	};

	makeHomeUser = { user, config }: {
		inherit (user) name;
		value = {
			imports = user.extraModules;
			home = {
				username = user.name;
				homeDirectory = "/home/${user.name}";
				inherit (config.hostSpec) stateVersion;
			};
		};
	};
}
