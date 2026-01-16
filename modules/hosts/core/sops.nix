{ inputs, config, pkgs, lib, ... }:
let
	inherit (config.hostSpec) hostname userList;
	secretsPath = (toString inputs.nix-secrets) + "/sops/hosts";
	defaultSopsFile = "${secretsPath}/${hostname}.yaml";

	secrets = let
			usernames = map (user: user.name) userList;
		in
			lib.mkMerge (map (name: {
				"${name}/password".neededForUsers = true;
				"${name}/age_key" = {
					owner = name;
					group = "users";
					path = "/home/${name}/.config/sops/age/keys.txt";
				};
				"wireless" = {
					owner = "wpa_supplicant";
					group = "wpa_supplicant";
				};
			}) usernames);
in {
	environment.systemPackages = with pkgs; [ age ];

	imports = [
		inputs.sops-nix.nixosModules.sops
	];

	sops = {
		age = {
			sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
			keyFile = "/var/lib/sops-nix/key.txt";
			generateKey = true;
		};

		validateSopsFiles = false;
		inherit defaultSopsFile secrets;
	};
}
