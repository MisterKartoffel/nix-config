{ pkgs, lib, ... }:
let
  keysModule = lib.types.submodule {
    options = {
      keys = lib.mkOption {
        description = "Authorized OpenSSH public keys";
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };

      keyFiles = lib.mkOption {
        description = "List of files containing one OpenSSH public key each";
        type = lib.types.listOf lib.types.path;
        default = [ ];
      };
    };
  };

  usersModule = lib.types.submodule {
    options = {
      description = lib.mkOption {
        description = "User description";
        type = lib.types.nullOr lib.types.str;
        default = null;
      };

      shell = lib.mkOption {
        description = "Default shell";
        type = lib.types.package;
        default = pkgs.bash;
      };

      extraGroups = lib.mkOption {
        description = "Groups to add to";
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };

      authorizedKeys = lib.mkOption {
        description = "Set of authorized OpenSSH keys";
        type = keysModule;
      };
    };
  };

  sopsModule = lib.types.submodule {
    options = {
      enable = lib.mkEnableOption "sops-nix integration";
    };
  };

  servicesModule = lib.types.submodule {
    options = {
      sops = lib.mkOption {
        description = "SOPS-Nix configuration";
        type = sopsModule;
      };
    };
  };
in
{
  options.modules = {
    users = lib.mkOption {
      description = "Users to create on this host";
      type = lib.types.attrsOf usersModule;
    };

    services = lib.mkOption {
      description = "System-wide service configuration";
      type = servicesModule;
    };
  };
}
