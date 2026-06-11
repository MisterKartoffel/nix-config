{ config, ... }:
let
  inherit (config.services) pipewire;
in
{
  security.rtkit.enable = pipewire.enable;
}
