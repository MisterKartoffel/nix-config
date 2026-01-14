{ lib, ... }:
let
	inherit (lib.types) listOf nullOr str path package submodule;
	inherit (lib) mkOption;
in {
	options.hostSpec = {
		hostname = mkOption {
			type = str;
			description = "Hostname for this host";
			default = "nixos";
		};

		stateVersion = mkOption {
			type = str;
			description = "NixOS version that was first installed in this host";
			default = "25.11";
		};

		systemArch = mkOption {
			type = str;
			description = "System architecture for this host";
			default = "x86_64-linux";
		};

		flakeRoot = mkOption {
			type = str;
			description = "Path to this flake on this host";
			default = "/home/username/nix-config";
		};

		userList = mkOption {
			type = listOf (
				submodule {
					options = {
						name = mkOption {
							type = str;
							description = "This user's username";
							default = "username";
						};

						description = mkOption {
							type = nullOr str;
							description = "This user's full name or description";
							default = null;
						};

						email = mkOption {
							type = nullOr str;
							description = "This user's e-mail address";
							default = null;
						};

						shell = mkOption {
							type = nullOr package;
							description = "This user's login shell";
							default = null;
						};

						extraGroups = mkOption {
							type = listOf str;
							description = "Extra groups for this user";
							default = [];
						};

						extraModules = mkOption {
							type = listOf path;
							description = "List of home-manager modules to import for this user";
							default = [];
						};

						authorizedKeyFiles = mkOption {
							type = listOf path;
							description = "List of authorized SSH key files for remote access to this user";
							default = [];
						};
					};
				}
			);

			description = "List of users on this host";
			default = [];
		};
	};
}
