{ lib, ... }:
{
  imports = lib.custom.importTree "modules/nixos";

  hardware.facter.reportPath = ./facter.json;
}
