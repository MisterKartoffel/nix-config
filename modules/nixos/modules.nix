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
      architecture = lib.mkOption {
        description = "System architecture";
        type = lib.types.str;
        default = "x86_64-linux";
      };

      users = lib.mkOption {
        description = "List of user entries to create on the system";
        type = usersModule;
        default = [ ];
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
  ];
}
