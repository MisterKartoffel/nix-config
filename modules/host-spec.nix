{ lib, ... }:
let
	inherit (lib.types) listOf nullOr str path submodule;
	inherit (lib) mkOption;
in {
	options.hostSpec = {
		hostname = mkOption {
			type = str;
			description = "Hostname for this host";
			default = "nixos";
		};

		stateVersion = mkOption {
			type = nullOr str;
			description = "NixOS version that was first installed in this host";
			default = null;
		};

		systemArch = mkOption {
			type = str;
			description = "System architecture for this host";
			default = "x86_64-linux";
		};

		flakeRoot = mkOption {
			type = nullOr str;
			description = "Absolute path to this flake on this host";
			default = null;
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

						shell = mkOption {
							type = nullOr str;
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
					};
				}
			);

			default = [];
			description = "List of users on this host";
		};
	};
}
