{
  config,
  lib,
  ...
}:
let
  usersModule = lib.types.attrsOf (
    lib.types.submodule {
      options = {
        autologin = lib.mkOption {
          description = "Should the system autologin this user.";
          type = lib.types.bool;
          default = false;
        };

        shell = lib.mkOption {
          description = "Default shell";
          type = lib.types.nullOr lib.types.str;
          default = null;
        };

        extraGroups = lib.mkOption {
          description = "Groups to add to";
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };
      };
    }
  );

  systemModule = lib.types.submodule {
    options = {
      users = lib.mkOption {
        description = "List of user entries to create on the system";
        type = usersModule;
        default = [ ];
      };
    };
  };

  impermanenceModule = lib.types.submodule {
    options = {
      enable = lib.mkEnableOption "Enable system-wide impermanence";

      path = lib.mkOption {
        description = "Path to persistent directory";
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
    };
  };

  sopsModule = lib.types.submodule {
    options = {
      enable = lib.mkOption {
        description = "Enable SOPS-Nix integration";
        type = lib.types.bool;
        default = true;
      };
    };
  };

  servicesModule = lib.types.submodule {
    options = {
      impermanence = lib.mkOption {
        description = "Impermanence configuration";
        type = impermanenceModule;
      };

      sops = lib.mkOption {
        description = "SOPS-Nix configuration";
        type = sopsModule;
      };
    };
  };
in
{
  options.modules = {
    system = lib.mkOption {
      description = "System-wide settings";
      type = systemModule;
    };

    services = lib.mkOption {
      description = "System-wide service configuration";
      type = servicesModule;
    };
  };

  config.assertions = [
    {
      assertion =
        let
          inherit (config.modules.system) users;
          autologinUsers = builtins.filter (username: users.${username}.autologin) (builtins.attrNames users);
        in
        builtins.length autologinUsers <= 1;

      message = "At most one user may have autologin = true";
    }
    {
      assertion =
        let
          inherit (config.modules.services) impermanence;
        in
        impermanence.enable -> impermanence.path != null;

      message = "Impermanence is enabled but the impermanence path is not set";
    }
  ];
}
