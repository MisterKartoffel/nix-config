{ lib, hostSpec, ... }:
{
  inherit hostSpec;

  imports = map lib.custom.relativeToRoot (
    [
      "modules/hosts/core"
    ]
    ++ map (file: "modules/hosts/optional/${file}") [
      "audio.nix"
      "networking.nix"
    ]
  );

  networking = {
    useNetworkd = true;
    wireless = {
      enable = true;

      networks = {
        "home" = {
          ssid = "JOSÉ LUIS OI FIBRA";
          pskRaw = "ext:home";
        };
      };
    };

    bond = {
      enable = true;

      bondName = "bond0";
      boundEthernet = [ "enp7s0" ];
      boundWireless = [ "wlp9s0" ];
    };
  };
}
