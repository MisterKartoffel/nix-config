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
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ age ];

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

          hostSecrets = lib.optionalAttrs config.networking.useNetworkd {
            "wireless" = {
              owner = "wpa_supplicant";
              group = "wpa_supplicant";
            };
          };
        in
        lib.mergeAttrs userSecrets hostSecrets;
    };
  };
}
