{
  inputs,
  config,
  ...
}:
let
  inherit (config.home) username homeDirectory;
  defaultSopsFile = "${inputs.nix-secrets}/sops/home/${username}.yaml";
in
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";

    validateSopsFiles = false;
    inherit defaultSopsFile;
    secrets."ssh_key".path = "${homeDirectory}/.ssh/id_ed25519";
  };
}
