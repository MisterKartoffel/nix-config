{ inputs, config, ... }:
let
	inherit (config.home) username homeDirectory;
	userKeyFile = "${homeDirectory}/.config/sops/age/keys.txt";
	secretsPath = builtins.toString inputs.nix-secrets;
in {
	imports = [ inputs.sops-nix.homeManagerModules.sops ];

	sops = {
		age.keyFile = userKeyFile;
		
		defaultSopsFile = "${secretsPath}/secrets.yaml";
		validateSopsFiles = false;

		secrets."${username}/ssh_key".path = "${homeDirectory}/.ssh/id_ed25519";
	};
}
