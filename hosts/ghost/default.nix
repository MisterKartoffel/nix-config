{
  modules = {
    system = {
      hostname = "ghost";
      architecture = "x86_64-linux";
      stateVersion = "25.11";

      submodules = [
        ../../modules/hosts
        ./hardware.nix
        ./packages.nix
      ];

      locale = {
        timezone = "America/Sao_Paulo";
        language = "en_US.UTF-8";
        overrides = {
          LC_ADDRESS = "pt_BR.UTF-8";
          LC_IDENTIFICATION = "pt_BR.UTF-8";
          LC_MEASUREMENT = "pt_BR.UTF-8";
          LC_MONETARY = "pt_BR.UTF-8";
          LC_NAME = "pt_BR.UTF-8";
          LC_NUMERIC = "pt_BR.UTF-8";
          LC_PAPER = "pt_BR.UTF-8";
          LC_TELEPHONE = "pt_BR.UTF-8";
          LC_TIME = "pt_BR.UTF-8";
        };
      };

      networking = {
        networkd = {
          enable = true;
          interfaces = [
            "enp7s0"
            "wlp9s0"
          ];
        };

        wireless = {
          enable = true;
          networks = {
            "home" = {
              ssid = "JOSÉ LUIS OI FIBRA";
              pskRaw = "ext:home";
            };
          };
        };

        bonding.enable = true;
      };

      users = [
        {
          name = "mimikyu";
          shell = "zsh";
          extraGroups = [
            "wheel"
            "video"
          ];
        }
      ];
    };

    services = {
      audio.enable = true;
      sops.enable = true;
      ssh.enable = true;
    };
  };
}
