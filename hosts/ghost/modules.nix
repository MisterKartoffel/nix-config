{ lib, ... }:
{
  imports = map lib.custom.relativeToRoot (
    [
      "hosts/common/core"
    ]
    ++ map (file: "hosts/common/optional/${file}.nix") [
      "audio"
      "networking"
      "sops"
      "torrenting"
    ]
  );

  hardware.facter.reportPath = ./facter.json;
}
