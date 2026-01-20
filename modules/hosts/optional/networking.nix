{
  config,
  lib,
  ...
}:
let
  makeNetdev = bondName: {
    netdevConfig = {
      Kind = "bond";
      Name = bondName;
    };

    bondConfig = {
      Mode = "active-backup";
      PrimaryReselectPolicy = "always";
      MIIMonitorSec = "1s";
      FailOverMACPolicy = "active";
    };
  };

  makeNetwork = interfaceName: bondName: {
    matchConfig.Name = interfaceName;
    networkConfig =
      if interfaceName == bondName then
        {
          BindCarrier = lib.concatStringsSep " " (
            config.networking.interfaceBond.boundEthernet ++ config.networking.interfaceBond.boundWireless
          );
          DHCP = "yes";
        }
      else
        {
          Bond = bondName;
        };
  };
in
{
  options = {
    networking.ifaceBond = {
      enable = lib.mkEnableOption "Enable interface bonding";

      bondName = lib.mkOption {
        type = lib.types.str;
        description = "Name of the bond interface";
        default = "bond0";
      };

      boundEthernet = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "List of ethernet interfaces to add to the bond";
        default = [ ];
      };

      boundWireless = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "List of wireless interfaces to add to the bond";
        default = [ ];
      };
    };
  };

  config =
    let
      inherit (config.networking) ifaceBond useNetworkd;
      inherit (ifaceBond) bondName boundEthernet boundWireless;
      allIfaces = boundEthernet ++ boundWireless;
    in
    {
      systemd.network = lib.mkIf useNetworkd {
        enable = true;

        netdevs = {
          "10-${bondName}" = makeNetdev bondName;
        };

        networks =
          (lib.mapAttrs (iface: _: makeNetwork iface bondName) (lib.genAttrs allIfaces (iface: { })))
          // {
            "40-${bondName}" = makeNetwork bondName bondName;
          };
      };

      networking = {
        hostName = config.hostspec.hostname;
        firewall.enable = true;

        nameservers = [
          "1.1.1.2#security.cloudflare-dns.com"
          "9.9.9.9#tls://dns.quad9.net"
        ];

        useNetworkd = lib.mkDefault false;
        networkmanager.enable = !useNetworkd;
        useDHCP = !useNetworkd;
        dhcpcd.enable = !useNetworkd;
      };
    };
}
