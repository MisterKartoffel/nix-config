{ config, lib, ... }:
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
      enable = lib.mkEnableOption "Enable networking configuration through systemd-networkd";

      interfaces = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Interfaces to be managed by systemd-networkd";
        default = [ ];
      };
    };
  };

  wirelessModule = lib.types.submodule {
    options = {
      enable = lib.mkEnableOption "Enable wireless support";

      networks = lib.mkOption {
        type = lib.types.attrs;
        description = "Wireless network configurations";
        default = { };
      };
    };
  };

  bondingModule = lib.types.submodule {
    options = {
      enable = lib.mkEnableOption "Enable interface bonding";

      bondName = lib.mkOption {
        type = lib.types.str;
        description = "Name of the bond interface";
        default = "bond0";
      };

      boundInterfaces = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Interfaces to add to the bond";
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
          type = lib.types.nullOr lib.types.str;
          description = "Username";
          default = null;
        };

        shell = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Default shell";
          default = null;
        };

        extraGroups = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "Groups to add to";
          default = [ ];
        };
      };
    }
  );

  systemModule = lib.types.submodule {
    options = {
      hostname = lib.mkOption {
        type = lib.types.str;
        description = "System hostname";
        default = "localhost";
      };

      architecture = lib.mkOption {
        type = lib.types.str;
        description = "System architecture";
        default = "x86_64-linux";
      };

      stateVersion = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = "Originally installed Nixpkgs version";
        default = null;
      };

      submodules = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        description = "List of NixOS modules";
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
      enable = lib.mkEnableOption "Enable SOPS-Nix integration";
    };
  };

  sshModule = lib.types.submodule {
    options = {
      enable = lib.mkEnableOption "Enable SSH services";
    };
  };

  servicesModule = lib.types.submodule {
    options = {
      audio = {
        enable = lib.mkEnableOption "Enable PipeWire audio server";
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
