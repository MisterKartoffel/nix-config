{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.modules.services) sops;
  inherit (config.modules) users;
  inherit (config.networking) hostName;
  inherit (config.services) openssh;
  inherit (config.system) etc;
  inherit (config) preservation;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    age.keyFile = "/var/lib/sops-nix/key.txt";
    defaultSopsFile = "${inputs.nix-secrets}/sops/hosts/common.yaml";
    validateSopsFiles = true;

    secrets = lib.mkIf sops.enable (
      {
        "access-tokens/github" = { };
      }
      //
      lib.optionalAttrs openssh.enable {
        "ssh_key" = {
          sopsFile = "${inputs.nix-secrets}/sops/hosts/${hostName}.yaml";
          mode = "0600";
          path = lib.mkIf (etc.overlay.enable -> etc.overlay.mutable) "/etc/ssh/ssh_host_ed25519_key";
        };
      }
      // lib.optionalAttrs preservation.enable {
        "rclone/password" = { };
        "restic/password" = { };
      }
      // lib.mergeAttrsList (
        map (
          username:
          let
            sopsFile = "${inputs.nix-secrets}/sops/users/${username}.yaml";
          in
          {
            "${username}/password" = {
              inherit sopsFile;
              key = "password";
              neededForUsers = true;
            };

            "${username}/age_key" = {
              inherit sopsFile;
              key = "age_key";
              owner = username;
              group = "users";
              mode = "0600";
            };

            "${username}/ssh_key" = lib.mkIf openssh.enable {
              inherit sopsFile;
              key = "ssh_key";
              owner = username;
              group = "users";
              mode = "0600";
            };

            "${username}/spotify/client_id" = {
              inherit sopsFile;
              key = "spotify/client_id";
              owner = username;
              group = "users";
              mode = "0600";
            };
          }
        ) (builtins.attrNames users)
      )
    );

    templates = {
      "nix-tokens.conf" = {
        file =
          (pkgs.formats.nixConf {
            inherit (config.nix) package;
            inherit (config.nix.package.out) version;
          }).generate
            "nix-tokens.conf"
            {
              extra-access-tokens = "github.com=${config.sops.placeholder."access-tokens/github"}";
            };
        group = "wheel";
        mode = "0440";
      };

      "restic-rclone.ini".content = lib.mkIf preservation.enable (
        lib.generators.toINI { } {
          mega = {
            type = "mega";
            user = "felipesdrs@hotmail.com";
            pass = config.sops.placeholder."rclone/password";
          };
        }
      );

      "myx-config.toml" = {
        file = (pkgs.formats.toml { }).generate "myx-config.toml" {
          client_id = config.sops.placeholder."mimikyu/spotify/client_id";
          protocol = "kitty";
        };
        owner = "mimikyu";
        group = "users";
        mode = "0600";
      };
    };
  };
}
