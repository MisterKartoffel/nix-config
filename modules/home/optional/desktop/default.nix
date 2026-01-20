{ lib, ... }:
{
  imports = lib.custom.importSelf ./.;
}
