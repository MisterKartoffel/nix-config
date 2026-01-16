{ lib, ... }: {
	imports = map lib.custom.relativeToRoot ([
		"hosts/common/core"
	] ++ (map (file: "hosts/common/optional/${file}") [
		"audio.nix"
	])) ++ lib.custom.importSelf ./.;
}
