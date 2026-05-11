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
