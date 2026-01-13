{ inputs, pkgs, lib, config, ... }: {
	users = {
		users = lib.listToAttrs (map (user:
			lib.custom.makeSystemUser { inherit user config; })
			(config.hostSpec.userList or []));
		mutableUsers = false;
	};

	home-manager = {
		users = lib.listToAttrs (map (user:
			lib.custom.makeHomeUser { inherit user config; })
			(config.hostSpec.userList or []));
		extraSpecialArgs = { inherit inputs pkgs; };
	};
}
