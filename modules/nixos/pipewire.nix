{ config, lib, ... }:
let
  inherit (config.services) pipewire;
in
{
  config = lib.mkIf pipewire.enable {
    services = {
      pulseaudio.enable = lib.mkForce false;

      pipewire = {
        alsa.enable = true;
        pulse.enable = true;
      };
    };

    security.rtkit.enable = true;
  };
}
