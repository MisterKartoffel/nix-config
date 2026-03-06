{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (config.home) username homeDirectory;
  inherit (lib) mkIf;
  cfg = config.modules.services.sops;
in
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = mkIf cfg.enable {
    age = {
      sshKeyPaths = [ "${homeDirectory}/.ssh/id_ed25519" ];
      keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
      generateKey = true;
    };

    defaultSopsFile = "${inputs.nix-secrets}/sops/home/${username}.yaml";
    validateSopsFiles = false;

    secrets = {
      "${username}/ssh_key" = {
        path = "${homeDirectory}/.ssh/id_ed25519";
        key = "ssh_key";
      };
      "email/hotmail/client_id" = {
        sopsFile = "${inputs.nix-secrets}/sops/common.yaml";
      };
      "email/hotmail/refresh_token" = {
        sopsFile = "${inputs.nix-secrets}/sops/common.yaml";
      };
    };
  };
}
