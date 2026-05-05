{ lib, ... }:
{
  imports = map lib.custom.relativeToRoot (
    [
      "hosts/common/core"
    ]
    ++ map (file: "hosts/common/optional/${file}") [
      "audio.nix"
      "networking.nix"
      "sops.nix"
    ]
  );

  hardware.facter.reportPath = ./facter.json;
}
