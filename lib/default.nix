{ lib, ... }: {
	makeSystemUser = { user, config }: let
		hashedPasswordFile =
			let secret =
				let
					key = user.passwordKey;
					secrets = config.sops.secrets or {};
				in
					if builtins.hasAttr key secrets then builtins.getAttr key secrets else null;
			in
				if secret == null then null else secret.path;
	in {
		inherit (user) name;
		value = {
			inherit (user) description shell extraGroups;
			inherit hashedPasswordFile;
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
