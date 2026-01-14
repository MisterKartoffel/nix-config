{ inputs, config, pkgs, lib, ... }:
let
	inherit (lib.custom) makeSystemUser makeHomeUser;
	inherit (config.hostSpec) userList;
	inherit (inputs) nix-secrets;
in {
	users = {
		users = lib.listToAttrs (map (user:
			makeSystemUser { inherit config pkgs user nix-secrets; }) userList);
		mutableUsers = false;
	};

	home-manager = {
		users = lib.listToAttrs (map (user:
			makeHomeUser { inherit config user; }) userList);
		extraSpecialArgs = { inherit inputs pkgs; };
	};
}
