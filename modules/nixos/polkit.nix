{ config, lib, ... }:
let
  inherit (config.security) polkit;
in
{
  security.polkit = lib.mkIf polkit.enable { };
}
