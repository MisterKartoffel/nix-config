{ inputs, pkgs, ... }:
let
	secretsPath = builtins.toString inputs.nix-secrets;
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

		secrets = {
			"mimikyu/password" = {
				key = "mimikyu/password";
				neededForUsers = true;
			};
		};
	};
}
