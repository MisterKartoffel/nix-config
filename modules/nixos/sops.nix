{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.networking) hostName;
  inherit (config.modules.system) users;

  nestAttrset =
    secrets:
    lib.foldlAttrs (
      acc: path: value:
      lib.recursiveUpdate acc (lib.attrsets.setAttrByPath (lib.splitString "/" path) value)
    ) { } secrets;

  inherit (config.modules.services) sops;
  inherit (config.services) openssh;
  inherit (config.networking) wireless;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  config = lib.mkIf sops.enable {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs)
        age
        sops
        ;
    };

    sops = {
      age.keyFile = "/var/lib/sops-nix/key.txt";
      defaultSopsFile = "${inputs.nix-secrets}/sops/hosts/${hostName}.yaml";
      validateSopsFiles = true;

      secrets =
        let
          hostSecrets = {
            "ssh_host_key" = lib.optionalAttrs openssh.enable {
              mode = "0600";
              path = "/etc/ssh/ssh_host_ed25519_key";
            };

            "wireless" = lib.optionalAttrs wireless.enable {
              owner = "wpa_supplicant";
              group = "wpa_supplicant";
            };
          };

          userSecrets = lib.mergeAttrsList (
            lib.mapAttrsToList (username: _: {
              "${username}/password".neededForUsers = true;
              "${username}/age_key" = {
                owner = username;
                group = "users";
                path = "/home/${username}/.config/sops/age/keys.txt";
              };
            }) users
          );
        in
        userSecrets // hostSecrets;
    };

    modules.secrets = {
      home = inputs.nix-secrets.home or { };
      host = lib.recursiveUpdate (nestAttrset (config.sops.secrets or { })) (
        inputs.nix-secrets.hosts.${hostName} or { }
      );
    };
  };

  options.modules.secrets = lib.mkOption {
    description = "Submodule of inputs.nix-secrets.home, inputs.nix-secrets.hosts.${hostName} and sops-nix secrets";

    type = lib.types.submodule {
      options = {
        home = lib.mkOption {
          description = "Home-manager unencrypted secrets";
          type = lib.types.attrs;
          default = { };
        };

        host = lib.mkOption {
          description = "NixOS secrets";
          type = lib.types.attrs;
          default = { };
        };
      };
    };

    default = { };
  };
}
