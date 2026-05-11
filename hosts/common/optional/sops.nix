{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (config.modules.system) hostname users;
  cfg = config.modules.services.sops;

  nestAttrset =
    secrets:
    lib.foldlAttrs (
      acc: path: value:
      lib.recursiveUpdate acc (lib.attrsets.setAttrByPath (lib.splitString "/" path) value)
    ) { } secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      age
      sops
    ];

    sops = {
      age = {
        sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        keyFile = "/var/lib/sops-nix/key.txt";
        generateKey = true;
      };

      defaultSopsFile = "${inputs.nix-secrets}/sops/hosts/${hostname}.yaml";
      validateSopsFiles = false;

      secrets =
        let
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

          hostSecrets = lib.optionalAttrs config.systemd.network.enable {
            "wireless" = {
              owner = "wpa_supplicant";
              group = "wpa_supplicant";
            };
          };
        in
        lib.mergeAttrs userSecrets hostSecrets;
    };

    modules.secrets = {
      home = inputs.nix-secrets.home or { };
      host = lib.recursiveUpdate (nestAttrset (config.sops.secrets or { })) (
        inputs.nix-secrets.hosts.${hostname} or { }
      );
    };
  };

  options.modules.secrets = lib.mkOption {
    description = "Submodule of inputs.nix-secrets.home, inputs.nix-secrets.hosts.${hostname} and sops-nix secrets";

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
