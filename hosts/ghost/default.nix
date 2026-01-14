{ config, ... }: {
	imports = [
		../common/core
		../common/optional/audio.nix

		./boot.nix
		./filesystems.nix
		./hardware.nix
		./networking.nix
		./packages.nix
	];

	system.stateVersion = config.hostSpec.stateVersion;
}
