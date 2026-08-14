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
        "access-tokens/github".sopsFile = "${inputs.nix-secrets}/sops/hosts/common.yaml";

        "ssh_key" = lib.mkIf openssh.enable {
          mode = "0600";
          path = lib.mkIf (etc.overlay.enable -> etc.overlay.mutable) "/etc/ssh/ssh_host_ed25519_key";
        };
      }
      // lib.optionalAttrs wireless.enable {
        "wireless/living_room" = { };
        "wireless/bedroom" = { };
      }
      // lib.optionalAttrs preservation.enable {
        "rclone/password".sopsFile = "${inputs.nix-secrets}/sops/hosts/common.yaml";
        "restic/password".sopsFile = "${inputs.nix-secrets}/sops/hosts/common.yaml";
      }
      // lib.mergeAttrsList (
        map (username: {
          "${username}/password" = {
            sopsFile = "${inputs.nix-secrets}/sops/users/${username}.yaml";
            key = "password";
            neededForUsers = true;
          };

          "${username}/age_key" = {
            sopsFile = "${inputs.nix-secrets}/sops/users/${username}.yaml";
            key = "age_key";
            owner = username;
            group = "users";
            mode = "0600";
            path = "/home/${username}/.config/sops/age/keys.txt";
          };

          "${username}/ssh_key" = lib.mkIf openssh.enable {
            sopsFile = "${inputs.nix-secrets}/sops/users/${username}.yaml";
            key = "ssh_key";
            owner = username;
            group = "users";
            mode = "0600";
            path = "/home/${username}/.ssh/id_ed25519";
          };
        }) (builtins.attrNames users)
      );

      templates = {
        "nix-tokens.conf" = {
          content = lib.generators.toKeyValue { mkKeyValue = lib.generators.mkKeyValueDefault { } " = "; }
            {
              extra-access-tokens = "github.com=${config.sops.placeholder."access-tokens/github"}";
            };
          group = "wheel";
          mode = "0440";
        };

        "wireless.conf" = lib.mkIf wireless.enable {
          content = lib.generators.toKeyValue { } {
            living_room = config.sops.placeholder."wireless/living_room";
            bedroom = config.sops.placeholder."wireless/bedroom";
          };
          owner = "wpa_supplicant";
          group = "wpa_supplicant";
        };

        "rclone.conf".content = lib.mkIf preservation.enable (
          lib.generators.toINI { } {
            mega = {
              type = "mega";
              user = "felipesdrs@hotmail.com";
              pass = config.sops.placeholder."rclone/password";
            };
          }
        );
      };
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
