{ lib }:
let
  makeNetwork =
    {
      interface,
      isBondEnabled,
      bondName,
      boundInterfaces,
    }:
    {
      matchConfig.Name = interface;
      networkConfig =
        if isBondEnabled && interface == bondName then
          {
            BindCarrier = lib.concatStringsSep " " boundInterfaces;
            DHCP = "yes";
          }
        else if isBondEnabled then
          {
            Bond = bondName;
          }
        else
          {
            DHCP = "yes";
          };
    };
in
{
  makeNetworks =
    {
      interfaces,
      isBondEnabled,
      bondName,
      boundInterfaces,
    }:
    lib.mkMerge [
      (lib.listToAttrs (
        map (interface: {
          name = "30-${interface}";
          value = makeNetwork {
            inherit
              interface
              bondName
              isBondEnabled
              boundInterfaces
              ;
          };
        }) interfaces
      ))

      (lib.mkIf isBondEnabled {
        "40-${bondName}" = makeNetwork {
          interface = bondName;
          inherit
            bondName
            isBondEnabled
            boundInterfaces
            ;
        };
      })
    ];

  makeBondNetdev = bondName: {
    "10-${bondName}" = {
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
  };
}
