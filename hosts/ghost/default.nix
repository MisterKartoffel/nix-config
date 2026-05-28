{
  imports = [ ./disko.nix ];

  modules = {
    system.users = {
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

    services = {
      sops.enable = true;

      impermanence = {
        enable = true;
        path = "/persist";
      };
    };
  };

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

  programs = {
    dconf.enable = true;
    niri.enable = true;
    zsh.enable = true;
  };

  security = {
    polkit.enable = true;
    run0 = {
      enableSudoAlias = true;
      wheelNeedsPassword = false;
    };
  };

  services = {
    pipewire.enable = true;
    qbittorrent.enable = false;
  };

  environment.pathsToLink = [ "/share/zsh" ];
  hardware.facter.reportPath = ./facter.json;
  zramSwap.enable = true;
}
