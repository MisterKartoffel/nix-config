{ config, lib, ... }:
let
  cfg = config.security.polkit;
in
{
  security.polkit = lib.mkIf cfg.enable { };
}
