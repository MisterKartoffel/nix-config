{
  system.stateVersion = "26.05";

  time.timeZone = "America/Sao_Paulo";
  console.keyMap = "br-abnt2";

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

    services = {
      audio.enable = true;
      sops.enable = true;
    };
  };
}
