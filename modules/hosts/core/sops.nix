{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.hostSpec) hostname userList;
  defaultSopsFile = "${inputs.nix-secrets}/sops/hosts/${hostname}.yaml";

  userSecrets = lib.mkMerge (
    map (user: {
      "${user.name}/password".neededForUsers = true;
      "${user.name}/age_key" = {
        owner = user.name;
        group = "users";
        path = "/home/${user.name}/.config/sops/age/keys.txt";
      };
    }) userList
  );

  hostSecrets = {
  }
  // lib.optionalAttrs config.networking.useNetworkd {
    "wireless" = {
      owner = "wpa_supplicant";
      group = "wpa_supplicant";
    };
  };
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];
  environment.systemPackages = with pkgs; [ age ];

  sops = {
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };

    inherit defaultSopsFile;
    validateSopsFiles = false;

    secrets = lib.mkMerge [
      userSecrets
      hostSecrets
    ];
  };
}
