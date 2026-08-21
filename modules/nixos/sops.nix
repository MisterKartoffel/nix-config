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
    defaultSopsFile = "${inputs.nix-secrets}/sops/hosts/${hostName}.yaml";
    validateSopsFiles = true;

    secrets = lib.mkIf sops.enable (
      {
        "ssh_key" = lib.mkIf openssh.enable {
          mode = "0600";
          path = lib.mkIf (etc.overlay.enable -> etc.overlay.mutable) "/etc/ssh/ssh_host_ed25519_key";
        };
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
          };

          "${username}/ssh_key" = lib.mkIf openssh.enable {
            sopsFile = "${inputs.nix-secrets}/sops/users/${username}.yaml";
            key = "ssh_key";
            owner = username;
            group = "users";
            mode = "0600";
          };

          "${username}/spotify/client_id" = {
            sopsFile = "${inputs.nix-secrets}/sops/users/${username}.yaml";
            key = "spotify/client_id";
            owner = username;
            group = "users";
            mode = "0600";
          };
        }) (builtins.attrNames users)
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
          client_id = "${config.sops.placeholder."mimikyu/spotify/client_id"}";
          protocol = "kitty";
        };
        owner = "mimikyu";
        group = "users";
        mode = "0600";
      };
    };
  };
}
