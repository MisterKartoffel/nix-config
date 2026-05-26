{ config, lib, ... }:
let
  inherit (config.services) pipewire;
in
{
  services = lib.mkIf pipewire.enable {
    pulseaudio.enable = lib.mkForce false;

    pipewire = {
      alsa.enable = true;
      pulse.enable = true;
    };
  };
}
