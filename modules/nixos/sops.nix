{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (config.modules.system) users;
  inherit (config.modules.services) sops;
  inherit (config.services) openssh;
  inherit (config.networking) hostName wireless;
  inherit (config.system) etc;

  nestAttrset =
    secrets:
    lib.foldlAttrs (
      acc: path: value:
      lib.recursiveUpdate acc (lib.attrsets.setAttrByPath (lib.splitString "/" path) value)
    ) { } secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  config = lib.mkIf sops.enable {
    sops = {
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
            "rclone/config" = { };
            "restic/password" = { };
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

    modules.secrets = nestAttrset (config.sops.secrets or { });
  };

  options.modules.secrets = lib.mkOption {
    description = "Attribute set of sops-nix secrets";
    type = lib.types.attrs;
    default = { };
  };
}
