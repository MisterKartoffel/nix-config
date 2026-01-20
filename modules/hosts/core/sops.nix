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

  userSecrets = lib.genAttrs (map (user: user.name) userList) (name: {
    "${name}/password".neededForUsers = true;
    "${name}/age_key" = {
      owner = name;
      group = "users";
      path = "/home/${name}/.config/sops/age/keys.txt";
    };
  });

  hostSecrets = lib.optionalAttrs config.networking.useNetworkd {
    "wireless" = {
      owner = "wpa_supplicant";
      group = "wpa_supplicant";
    };
  };

  secrets = userSecrets // hostSecrets;
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

    validateSopsFiles = false;
    inherit defaultSopsFile secrets;
  };
}
