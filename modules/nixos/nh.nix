{ config, lib, ... }:
let
  inherit (config.programs) nh;
in
{
  programs.nh = lib.mkIf nh.enable {
    clean = {
      enable = true;
      dates = "daily";
      extraArgs = "--keep 3";
    };
  };
}
