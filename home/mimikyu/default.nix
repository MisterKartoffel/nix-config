{ lib, ... }: {
	imports = map lib.custom.relativeToRoot ([
		"home/common/core"
	] ++ (map (file: "home/common/optional/${file}") [
		"desktop"
		"neovim"
		"theming"
	])) ++ lib.custom.importSelf ./.;
}
