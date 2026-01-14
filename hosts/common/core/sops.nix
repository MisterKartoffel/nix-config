{ config, lib, inputs, pkgs, ... }:
let
	secretsPath = builtins.toString inputs.nix-secrets;
	userSecrets = user: {
		"${user.name}/password".neededForUsers = true;
		"${user.name}/age_key" = {
			owner = user.name;
			group = "users";
			path = "/home/${user.name}/.config/sops/age/keys.txt";
		};
	};
in {
	environment.systemPackages = with pkgs; [ age ];

	imports = [
		inputs.sops-nix.nixosModules.sops
	];

	sops = {
		defaultSopsFile = "${secretsPath}/secrets.yaml";
		validateSopsFiles = false;

		age = {
			sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
			keyFile = "/var/lib/sops-nix/key.txt";
			generateKey = true;
		};

		secrets = lib.mkMerge (map userSecrets config.hostSpec.userList);
	};
}
