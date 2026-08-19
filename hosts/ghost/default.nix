{ config, ... }:
{
  modules = {
    users."mimikyu" = {
      description = "Felipe Duarte";
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
      secretsFile = config.sops.templates."wireless.conf".path;
      networks = {
        "JOSE LUIS".pskRaw = "ext:living_room";
        "FELIPE DUARTE".pskRaw = "ext:bedroom";
      };
    };
  };

  fonts.fontconfig.enable = true;
  qt.enable = true;

  programs = {
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

  environment.pathsToLink = map (path: "/share/fish/vendor_${path}.d") [
    "conf"
    "completions"
    "functions"
  ];

  hardware.amdgpu.legacySupport.enable = true;
  hardware.facter.reportPath = ./facter.json;
  boot.zswap.enable = true;

  # Closure size optimizations
  services.speechd.enable = false;
}
