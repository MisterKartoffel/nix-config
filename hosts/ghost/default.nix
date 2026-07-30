{ pkgs, ... }:
{
  modules = {
    users."mimikyu" = {
      description = "Felipe Duarte";
      autologin = true;
      shell = pkgs.zsh;
      extraGroups = [
        "wheel"
        "qbt"
        "video"
      ];
    };

    services.sops.enable = true;
  };

  system.stateVersion = "26.05";
  preservation.enable = true;

  time.timeZone = "America/Sao_Paulo";
  console.keyMap = "br-abnt2";

  networking = {
    hostName = "ghost";

    useNetworkd = true;
    nftables.enable = true;
    wireless = {
      enable = true;
      secretsFile = "/run/secrets/wireless";
      networks = {
        "JOSE LUIS".pskRaw = "ext:sala";
        "FELIPE DUARTE".pskRaw = "ext:quarto";
      };
    };
  };

  fonts.fontconfig.enable = true;
  qt.enable = true;

  programs = {
    direnv.enable = true;
    git.enable = true;
    nh.enable = true;
    niri.enable = true;
    zsh.enable = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
    run0.enable = true;
  };

  services = {
    openssh.enable = true;
    playerctld.enable = true;
    qbittorrent.enable = true;
    resolved.enable = true;
    watt.enable = true;
  };

  environment.pathsToLink = [ "/share/zsh" ];
  hardware.amdgpu.legacySupport.enable = true;
  hardware.facter.reportPath = ./facter.json;
  boot.zswap.enable = true;
}
