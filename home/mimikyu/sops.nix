{ inputs, config, ... }:
let
	inherit (config.home) username homeDirectory;
	userKeyFile = "${homeDirectory}/.config/sops/age/keys.txt";
	secretsPath = (toString inputs.nix-secrets) + "/sops/home";
in {
	imports = [ inputs.sops-nix.homeManagerModules.sops ];

	sops = {
		age.keyFile = userKeyFile;
		
		defaultSopsFile = "${secretsPath}/${username}.yaml";
		validateSopsFiles = false;

		secrets."ssh_key".path = "${homeDirectory}/.ssh/id_ed25519";
	};
}
