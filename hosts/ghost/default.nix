{
  modules = {
    system = {
      architecture = "x86_64-linux";

      submodules = [
        ./disko.nix
        ./impermanence.nix
        ./packages.nix
      ];

      users = {
        "mimikyu" = {
          autologin = true;
          shell = "zsh";
          extraGroups = [
            "wheel"
            "qbt"
            "video"
          ];
        };
      };
    };

    services.sops.enable = true;
  };

  system.stateVersion = "26.05";

  time.timeZone = "America/Sao_Paulo";
  console.keyMap = "br-abnt2";

  environment.persistence."/etc/persist".enable = true;

  networking = {
    hostName = "ghost";

    useNetworkd = true;
    wireless = {
      enable = true;
      secretsFile = "/run/secrets/wireless";
      networks = {
        "JOSE LUIS".pskRaw = "ext:home";
      };
    };
  };

  security = {
    polkit.enable = true;
    run0.enableSudoAlias = true;
  };

  services = {
    pipewire.enable = true;
    qbittorrent.enable = false;
  };

  hardware.facter.reportPath = ./facter.json;
}
