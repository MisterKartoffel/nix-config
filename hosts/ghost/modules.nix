{ lib, ... }:
{
  imports = lib.custom.makeImport "modules/nixos";

  hardware.facter.reportPath = ./facter.json;
}
