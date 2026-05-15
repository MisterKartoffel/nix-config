{
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

  modules = {
    system = {
      architecture = "x86_64-linux";

      submodules = [
        ./disko.nix
        ./impermanence.nix
        ./modules.nix
        ./packages.nix
      ];

      users = [
        {
          name = "mimikyu";
          shell = "zsh";
          extraGroups = [
            "wheel"
            "qbt"
            "video"
          ];
        }
      ];
    };

    services.sops.enable = true;
  };

  services = {
    pipewire.enable = true;
    qbittorrent.enable = false;
  };
}
