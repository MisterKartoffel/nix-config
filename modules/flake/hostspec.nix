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

    modules = mkOption {
      type = listOf path;
      description = "List of NixOS module files for this host";
      default = [ ];
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
