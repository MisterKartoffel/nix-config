{ config, lib, ... }:
let
  cfg = config.programs.nh;
in
{
  programs.nh.flake = lib.mkIf cfg.enable "/home/mimikyu/nix-config/";
}
