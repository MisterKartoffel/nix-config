{ lib, ... }: {
	imports = lib.custom.importSelf ./.;

	options.home-manager.users.*.custom.graphical = {
		enable = lib.mkEnableOption "Enable graphical environment";
	};
}
