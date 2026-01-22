{
  inputs,
  config,
  ...
}:
let
  inherit (config.home) username homeDirectory;
  defaultSopsFile = "${inputs.nix-secrets}/sops/home/${username}.yaml";
  sopsFile = "${inputs.nix-secrets}/sops/common.yaml";
in
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    age = {
      sshKeyPaths = [ "${homeDirectory}/.ssh/id_ed25519" ];
      keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
      generateKey = true;
    };

    inherit defaultSopsFile;
    validateSopsFiles = false;

    secrets = {
      "mimikyu/ssh_key" = {
        path = "${homeDirectory}/.ssh/id_ed25519";
        key = "ssh_key";
      };
      "email/hotmail/client_id" = { inherit sopsFile; };
      "email/hotmail/refresh_token" = { inherit sopsFile; };
    };
  };
}
