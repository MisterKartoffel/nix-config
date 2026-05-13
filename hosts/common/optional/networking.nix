{ config, lib, ... }:
let
  cfg = config.networking;
  ifaces = config.hardware.facter.detected.dhcp.interfaces;
  bondName = "bond0";
in
{
  systemd.network = lib.mkIf cfg.useNetworkd (
    lib.mkMerge [
      {
        enable = true;
        wait-online.anyInterface = true;
      }
      (lib.mkIf (ifaces != [ ]) {
        netdevs = {
          "10-${bondName}" = {
            netdevConfig = {
              Kind = "bond";
              Name = bondName;
            };
            bondConfig = {
              Mode = "active-backup";
              PrimaryReselectPolicy = "better";
              MIIMonitorSec = 100;
            };
          };
        };

        networks =
          lib.listToAttrs (
            map (iface: {
              name = "20-${iface}";
              value = {
                matchConfig.Name = iface;
                networkConfig.Bond = bondName;
              };
            }) ifaces
          )
          // {
            "40-${bondName}" = {
              matchConfig.Name = bondName;
              linkConfig.RequiredForOnline = "carrier";
              networkConfig = {
                BindCarrier = lib.concatStringsSep " " ifaces;
                DHCP = "yes";
              };
            };
          };
      })
    ]
  );

  networking = lib.mkMerge [
    {
      firewall.enable = true;

      nameservers = [
        "1.1.1.2#security.cloudflare-dns.com"
        "9.9.9.9#tls://dns.quad9.net"
      ];
    }
    (lib.mkIf (!cfg.useNetworkd || ifaces == [ ]) {
      networkmanager.enable = !cfg.useNetworkd;
      useDHCP = !cfg.useNetworkd;
      dhcpcd.enable = !cfg.useNetworkd;
    })
  ];
}
