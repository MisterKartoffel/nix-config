{ ... }: {
	makeSystemUser = { inputs, config, pkgs, user }: {
		inherit (user) name;
		value = {
			inherit (user) extraGroups;
			shell = pkgs.${user.shell};
			description = inputs.nix-secrets.name;
			hashedPasswordFile = config.sops.secrets."${user.name}/password".path;

			openssh.authorizedKeys.keyFiles =
				let
					keyDir = builtins.path { path = ../home/${user.name}/keys; };
				in 
					map (file: "${keyDir}/${file}")
						(builtins.attrNames (builtins.readDir keyDir));

			isNormalUser = true;
		};
	};

	makeHomeUser = { config, user }: {
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
