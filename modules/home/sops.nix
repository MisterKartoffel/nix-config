{
  osConfig,
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (osConfig.modules.services) sops;
  inherit (config.home) username homeDirectory;
  inherit (config.programs) ssh;
in
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = lib.mkIf sops.enable {
    age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = "${inputs.nix-secrets}/sops/home/${username}.yaml";
    validateSopsFiles = true;

    secrets = {
      "ssh_key".path = lib.mkIf ssh.enable "${homeDirectory}/.ssh/id_ed25519";
      "ufrgs/password" = { };
    };
  };
}
