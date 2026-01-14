{ inputs, ... }: {
	makeSystemUser = { user, config }: {
		inherit (user) name;
		value = {
			inherit (user) shell extraGroups;
			description = inputs.nix-secrets.name;
			hashedPasswordFile = config.sops.secrets."${user.name}/password".path;
			openssh.authorizedKeys.keyFiles = user.authorizedKeyFiles;
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
