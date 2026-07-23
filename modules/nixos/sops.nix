{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (config.modules.services) sops;
  inherit (config.modules) users;
  inherit (config.networking) hostName wireless;
  inherit (config.services) openssh;
  inherit (config.system) etc;
  inherit (config) preservation;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  config = lib.mkIf sops.enable {
    sops = {
      age.keyFile = "/var/lib/sops-nix/key.txt";
      defaultSopsFile = "${inputs.nix-secrets}/sops/hosts/${hostName}.yaml";
      validateSopsFiles = true;

      secrets = {
        "ssh_key" = lib.mkIf openssh.enable {
          mode = "0600";
          path = lib.mkIf (etc.overlay.enable -> etc.overlay.mutable) "/etc/ssh/ssh_host_ed25519_key";
        };

        "wireless" = lib.mkIf wireless.enable {
          owner = "wpa_supplicant";
          group = "wpa_supplicant";
        };
      }
      // lib.optionalAttrs preservation.enable {
        "rclone/config".sopsFile = "${inputs.nix-secrets}/sops/common.yaml";
        "restic/password".sopsFile = "${inputs.nix-secrets}/sops/common.yaml";
      }
      // lib.mergeAttrsList (
        map (username: {
          "${username}/password" = {
            sopsFile = "${inputs.nix-secrets}/sops/home/${username}.yaml";
            key = "password";
            neededForUsers = true;
          };

          "${username}/age_key" = {
            sopsFile = "${inputs.nix-secrets}/sops/home/${username}.yaml";
            key = "age_key";
            owner = username;
            group = "users";
            mode = "0600";
            path = "/home/${username}/.config/sops/age/keys.txt";
          };

          "${username}/ssh_key" = lib.mkIf openssh.enable {
            sopsFile = "${inputs.nix-secrets}/sops/home/${username}.yaml";
            key = "ssh_key";
            owner = username;
            group = "users";
            mode = "0600";
            path = "/home/${username}/.ssh/id_ed25519";
          };
        }) (builtins.attrNames users)
      );
    };

    /*
      Workaround for incorrect permissions in directories
      under $HOME causing hjem activation to fail
    */
    systemd.tmpfiles.settings.sops =
      let
        paths = [
          ".ssh"
          ".config/sops"
          ".config/sops/age"
        ];
      in
      lib.concatMapAttrs (
        username: _:
        lib.genAttrs' paths (path: {
          name = "/home/${username}/${path}";
          value.d = {
            user = username;
            group = "users";
            mode = "0700";
          };
        })
      ) users;
  };
}
