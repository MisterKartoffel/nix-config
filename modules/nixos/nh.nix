{ config, lib, ... }:
let
  inherit (config.programs) nh;
in
{
  programs.nh.clean = lib.mkIf nh.enable {
    enable = true;
    dates = "daily";
    extraArgs = "--keep 3";
  };
}
