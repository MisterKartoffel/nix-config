{ config, lib, ... }:
let
  inherit (lib) mkIf;
  cfg = config.modules.system.networking;
in
{
  systemd.network = mkIf cfg.networkd.enable {
    enable = true;

    netdevs = mkIf cfg.bonding.enable (lib.custom.makeBondNetdev cfg.bonding.bondName);

    networks = lib.custom.makeNetworks {
      inherit (cfg.networkd) interfaces;
      inherit (cfg.bonding) bondName boundInterfaces;
      isBondEnabled = cfg.bonding.enable;
    };
  };

  networking = {
    hostName = config.modules.system.hostname;
    wireless = { inherit (cfg.wireless) enable networks; };
    firewall.enable = true;

    nameservers = [
      "1.1.1.2#security.cloudflare-dns.com"
      "9.9.9.9#tls://dns.quad9.net"
    ];

    networkmanager.enable = !cfg.networkd.enable;
    useDHCP = !cfg.networkd.enable;
    dhcpcd.enable = !cfg.networkd.enable;
  };
}
