{ config, lib, ... }:
let
  inherit (config) zramSwap;
  GBToBytes = GB: GB * 1024 * 1024 * 1024;
in
{
  zramSwap.memoryMax = lib.mkIf zramSwap.enable (GBToBytes 4);
}
