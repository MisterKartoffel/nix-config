{ inputs, config, ... }:
let
	inherit (config.home) username homeDirectory;
	secretsPath = (toString inputs.nix-secrets) + "/sops/home";
	defaultSopsFile = "${secretsPath}/${username}.yaml";
in {
	imports = [ inputs.sops-nix.homeManagerModules.sops ];

	sops = {
		age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
		
		validateSopsFiles = false;
		inherit defaultSopsFile;
		secrets."ssh_key".path = "${homeDirectory}/.ssh/id_ed25519";
	};
}
