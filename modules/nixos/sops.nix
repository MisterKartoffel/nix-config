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
      age = {
        sshKeyPaths = lib.mkIf openssh.enable [ "/etc/ssh/ssh_host_ed25519_key" ];
        keyFile = "/var/lib/sops-nix/key.txt";
        generateKey = false;
      };

      defaultSopsFile = "${inputs.nix-secrets}/sops/hosts/${hostName}.yaml";
      validateSopsFiles = false;

      secrets =
        let
          hostSecrets = {
            "ssh_host_key" = lib.optionalAttrs config.services.openssh.enable {
              mode = "0600";
              path = "/etc/ssh/ssh_host_ed25519_key";
            };
            "wireless" = lib.optionalAttrs config.networking.wireless.enable {
              owner = "wpa_supplicant";
              group = "wpa_supplicant";
            };
          };

          userSecrets = lib.foldl' lib.mergeAttrs { } (
            map (user: {
              "${user.name}/password".neededForUsers = true;
              "${user.name}/age_key" = {
                owner = user.name;
                group = "users";
                path = "/home/${user.name}/.config/sops/age/keys.txt";
              };
            }) users
          );
        in
        lib.mergeAttrs userSecrets hostSecrets;
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
