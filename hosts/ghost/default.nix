{ lib, ... }: {
	imports = map lib.custom.relativeToRoot ([
		"modules/hosts/core"
	] ++ (map (file: "modules/hosts/optional/${file}") [
		"audio.nix"
	])) ++ lib.custom.importSelf ./.;
}
