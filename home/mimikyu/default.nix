{ lib, ... }: {
	imports = map lib.custom.relativeToRoot [
		"modules/home/core"
		"modules/home/optional"
	] ++ lib.custom.importSelf ./.;

	custom = {
		graphical.enable = true;
		neovim.enable = true;
	};
}
