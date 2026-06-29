{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (config.modules.system) users;
  inherit (config.modules.services) impermanence sops;
  inherit (config.services) openssh;
  inherit (config.networking) hostName wireless;
  inherit (config.system) etc;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = lib.mkIf sops.enable {
    age.keyFile = "/var/lib/sops-nix/key.txt";
    defaultSopsFile = "${inputs.nix-secrets}/sops/hosts/${hostName}.yaml";
    validateSopsFiles = true;

    secrets =
      let
        hostSecrets = {
          "ssh_key" = lib.mkIf openssh.enable {
            mode = "0600";
            path = lib.mkIf (etc.overlay.enable -> etc.overlay.mutable) "/etc/ssh/ssh_host_ed25519_key";
          };

          "wireless" = lib.mkIf wireless.enable {
            owner = "wpa_supplicant";
            group = "wpa_supplicant";
          };
        }
        // lib.optionalAttrs impermanence.enable {
          "rclone/config".sopsFile = "${inputs.nix-secrets}/sops/common.yaml";
          "restic/password".sopsFile = "${inputs.nix-secrets}/sops/common.yaml";
        };

        userSecrets = lib.mergeAttrsList (
          map (username: {
            "${username}/password".neededForUsers = true;

            "${username}/age_key" = {
              owner = username;
              group = "users";
              mode = "0600";
              path = "/home/${username}/.config/sops/age/keys.txt";
            };
          }) (builtins.attrNames users)
        );
      in
      userSecrets // hostSecrets;
  };
}
