{ pkgs, ... }:
{
  imports = [ ./disko.nix ];

  modules = {
    system = {
      machine-id = "34b006cd91c04059beb077f7cb4f6e1e";

      users = {
        "mimikyu" = {
          autologin = true;
          shell = pkgs.zsh;
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
    nh.enable = true;
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
    qbittorrent.enable = true;
  };

  environment.pathsToLink = [ "/share/zsh" ];
  hardware.facter.reportPath = ./facter.json;
  zramSwap.enable = true;
}
