{ config, ... }: {
	imports = [
		../common/core

		./boot.nix
		./filesystems.nix
		./hardware.nix
		./locale.nix
		./networking.nix
		./packages.nix
		./ssh.nix
	];

	system.stateVersion = config.hostSpec.stateVersion;
}
