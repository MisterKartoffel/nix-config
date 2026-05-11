{
  config,
  lib,
  ...
}:
let
  usersModule = lib.types.listOf (
    lib.types.submodule {
      options = {
        name = lib.mkOption {
          description = "Username";
          type = lib.types.nullOr lib.types.str;
          default = null;
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

      submodules = lib.mkOption {
        description = "List of NixOS modules";
        type = lib.types.listOf lib.types.path;
        default = [ ];
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
        default = false;
      };
    };
  };

  sshModule = lib.types.submodule {
    options = {
      enable = lib.mkOption {
        description = "Enable SSH services";
        type = lib.types.bool;
        default = config.modules.sops.enable;
      };
    };
  };

  servicesModule = lib.types.submodule {
    options = {
      audio = {
        enable = lib.mkOption {
          description = "Enable PipeWire audio server";
          type = lib.types.bool;
          default = false;
        };
      };

      sops = lib.mkOption {
        description = "SOPS-Nix configuration";
        type = sopsModule;
      };

      ssh = lib.mkOption {
        description = "System-wide SSH configuration";
        type = sshModule;
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
}
