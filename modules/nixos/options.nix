{ pkgs, lib, ... }:
let
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
