{ inputs, pkgs, lib, config, ... }:
let
	inherit (lib.custom) makeSystemUser makeHomeUser;
	inherit (config.hostSpec) userList;
	inherit (inputs) nix-secrets;
in {
	users = {
		users = lib.listToAttrs (map (user:
			makeSystemUser { inherit user config pkgs nix-secrets; }) userList);
		mutableUsers = false;
	};

	home-manager = {
		users = lib.listToAttrs (map (user:
			makeHomeUser { inherit user config; }) userList);
		extraSpecialArgs = { inherit inputs pkgs; };
	};
}
