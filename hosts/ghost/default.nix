{
  systemd.network.enable = true;

  networking = {
    wireless = {
      enable = true;
      secretsFile = "/run/secrets/wireless";
      networks = {
        "JOSÉ LUIS OI FIBRA".pskRaw = "ext:home";
      };
    };
  };

  modules = {
    system = {
      hostname = "ghost";
      architecture = "x86_64-linux";

      submodules = [
        ./disko.nix
        ./modules.nix
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
