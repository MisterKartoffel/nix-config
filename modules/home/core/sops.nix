{
  inputs,
  config,
  ...
}:
let
  inherit (config.home) username homeDirectory;
in
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = "${inputs.nix-secrets}/sops/home/${username}.yaml";
    validateSopsFiles = false;

    secrets = {
      "ssh_key" = {
        path = "${homeDirectory}/.ssh/id_ed25519";
      };
    };
  };
}
