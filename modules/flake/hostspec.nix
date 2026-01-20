{ lib, ... }:
let
  inherit (lib.types)
    listOf
    nullOr
    str
    path
    submodule
    ;
  inherit (lib) mkOption;
in
{
  options.hostSpec = {
    hostname = mkOption {
      type = str;
      description = "Hostname for this host";
      default = "nixos";
    };

    system = mkOption {
      type = str;
      description = "System architecture for this host";
      default = "x86_64-linux";
    };

    stateVersion = mkOption {
      type = nullOr str;
      description = "NixOS version that was first installed in this host";
      default = null;
    };

    flakeRoot = mkOption {
      type = nullOr str;
      description = "Absolute path to this flake on this host";
      default = null;
    };

    userList = mkOption {
      type = listOf (submodule {
        options = {
          name = mkOption {
            type = str;
            description = "Username";
            default = "username";
          };

          shell = mkOption {
            type = nullOr str;
            description = "Login shell";
            default = null;
          };

          homeModule = mkOption {
            type = nullOr path;
            description = "Entrypoint module for home-manager configuration";
            default = null;
          };

          extraGroups = mkOption {
            type = listOf str;
            description = "Extra groups for this user";
            default = [ ];
          };
        };
      });

      default = [ ];
      description = "List of users on this host";
    };
  };
}
