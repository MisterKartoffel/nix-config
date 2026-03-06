{
  config,
  lib,
  ...
}:
let
  localeVariables = [
    "LC_ADDRESS"
    "LC_COLLATE"
    "LC_CTYPE"
    "LC_IDENTIFICATION"
    "LC_MEASUREMENT"
    "LC_MESSAGES"
    "LC_MONETARY"
    "LC_NAME"
    "LC_NUMERIC"
    "LC_PAPER"
    "LC_TELEPHONE"
    "LC_TIME"
  ];

  localeStrings = [
    "C"
    "en_US.UTF-8"
    "pt_BR.UTF-8"
  ];

  localeModule = lib.types.submodule {
    options = {
      timezone = lib.mkOption {
        type = lib.types.str;
        description = "System timezone";
        default = "America/Sao_Paulo";
      };

      language = lib.mkOption {
        type = lib.types.enum localeStrings;
        description = "System language";
        default = "en_US.UTF-8";
      };

      overrides = lib.mkOption {
        type = lib.types.attrsOf (lib.types.enum localeStrings);
        description = "LC_* locale overrides";
        default = { };
      };
    };
  };

  networkdModule = lib.types.submodule {
    options = {
      enable = lib.mkOption {
        description = "Enable networking configuration through systemd-networkd";
        type = lib.types.bool;
        default = false;
      };

      interfaces = lib.mkOption {
        description = "Interfaces to be managed by systemd-networkd";
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };
    };
  };

  wirelessModule = lib.types.submodule {
    options = {
      enable = lib.mkOption {
        description = "Enable wireless support";
        type = lib.types.bool;
        default = false;
      };

      networks = lib.mkOption {
        description = "Wireless network configurations";
        type = lib.types.attrs;
        default = { };
      };
    };
  };

  bondingModule = lib.types.submodule {
    options = {
      enable = lib.mkOption {
        description = "Enable interface bonding";
        type = lib.types.bool;
        default = false;
      };

      bondName = lib.mkOption {
        description = "Name of the bond interface";
        type = lib.types.str;
        default = "bond0";
      };

      boundInterfaces = lib.mkOption {
        description = "Interfaces to add to the bond";
        type = lib.types.listOf lib.types.str;
        default = config.modules.system.networking.networkd.interfaces;
      };
    };
  };

  networkingModule = lib.types.submodule {
    options = {
      networkd = lib.mkOption {
        description = "systemd-networkd specific settings";
        type = networkdModule;
      };

      wireless = lib.mkOption {
        description = "Configuration module for Wi-Fi";
        type = wirelessModule;
      };

      bonding = lib.mkOption {
        description = "Settings for interface bonding via systemd-networkd";
        type = bondingModule;
      };
    };
  };

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
      hostname = lib.mkOption {
        description = "System hostname";
        type = lib.types.str;
        default = "localhost";
      };

      architecture = lib.mkOption {
        description = "System architecture";
        type = lib.types.str;
        default = "x86_64-linux";
      };

      stateVersion = lib.mkOption {
        description = "Originally installed Nixpkgs version";
        type = lib.types.nullOr lib.types.str;
        default = null;
      };

      submodules = lib.mkOption {
        description = "List of NixOS modules";
        type = lib.types.listOf lib.types.path;
        default = [ ];
      };

      locale = lib.mkOption {
        description = "System locale settings";
        type = localeModule;
      };

      networking = lib.mkOption {
        description = "Networking settings";
        type = networkingModule;
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

    secrets = lib.mkOption {
      description = "Nested attribute set of secrets";
      type = lib.types.attrs;
      default = { };
    };
  };
}
