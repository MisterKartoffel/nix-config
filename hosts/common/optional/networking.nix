{ config, lib, ... }:
let
  cfg = config.systemd.network;
in
{
  systemd.network = lib.mkIf config.systemd.network.enable {
    wait-online.anyInterface = true;

    netdevs = {
      "10-bond0" = {
        netdevConfig = {
          Kind = "bond";
          Name = "bond0";
        };
        bondConfig = {
          Mode = "active-backup";
          PrimaryReselectPolicy = "better";
          MIIMonitorSec = 100;
        };
      };
    };

    networks = {
      "20-enp7s0" = {
        matchConfig.Name = "enp7s0";
        networkConfig.Bond = "bond0";
      };

      "30-wlp9s0" = {
        matchConfig.Name = "wlp9s0";
        networkConfig.Bond = "bond0";
      };

      "40-bond0" = {
        matchConfig.Name = "bond0";
        linkConfig.RequiredForOnline = "carrier";
        networkConfig = {
          BindCarrier = "enp7s0 wlp9s0";
          DHCP = "yes";
        };
      };
    };
  };

  networking = {
    hostName = config.modules.system.hostname;
    firewall.enable = true;

    nameservers = [
      "1.1.1.2#security.cloudflare-dns.com"
      "9.9.9.9#tls://dns.quad9.net"
    ];

    networkmanager.enable = !cfg.enable;
    useDHCP = !cfg.enable;
    dhcpcd.enable = !cfg.enable;
  };
}
