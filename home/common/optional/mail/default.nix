{ lib, ... }:
{
  imports = lib.custom.importPaths [ ./. ];
}
