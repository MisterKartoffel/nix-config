{ config, ... }: {
	imports = [
		../common

		./boot.nix
		./filesystems.nix
		./hardware.nix
		./locale.nix
		./networking.nix
		./packages.nix
		./sops.nix
		./ssh.nix
	];

	system.stateVersion = config.hostSpec.stateVersion;
}
