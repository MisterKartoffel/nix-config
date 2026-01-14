{ lib, ... }:
let
	inherit (lib) types;
in {
	options.hostSpec = {
		hostname = lib.mkOption {
			type = types.str;
			description = "Hostname for this host";
			default = "nixos";
		};

		stateVersion = lib.mkOption {
			type = types.str;
			description = "NixOS version that was first installed in this host";
		};

		systemArch = lib.mkOption {
			type = types.str;
			description = "System architecture for this host";
			default = "x86_64-linux";
		};

		flakeRoot = lib.mkOption {
			type = types.str;
			description = "Path to this flake on this host";
		};

		userList = lib.mkOption {
			type = types.listOf (
				types.submodule {
					options = {
						name = lib.mkOption {
							type = types.str;
							description = "This user's username";
						};

						description = lib.mkOption {
							type = types.nullOr types.str;
							description = "This user's full name or description";
							default = null;
						};

						email = lib.mkOption {
							type = types.nullOr types.str;
							description = "This user's e-mail address";
							default = null;
						};

						shell = lib.mkOption {
							type = types.nullOr types.package;
							description = "This user's login shell";
							default = null;
						};

						extraGroups = lib.mkOption {
							type = types.listOf types.str;
							description = "Extra groups for this user";
							default = [];
						};

						extraModules = lib.mkOption {
							type = types.listOf types.path;
							description = "List of home-manager modules to import for this user";
							default = [];
						};
					};
				}
			);
			description = "List of users on this host";
		};
	};
}
