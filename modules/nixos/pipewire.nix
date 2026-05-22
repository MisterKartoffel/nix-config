{ config, lib, ... }:
let
  inherit (config.services) pipewire;
in
{
  services = lib.mkIf pipewire.enable {
    pulseaudio.enable = lib.mkForce false;

    pipewire = {
      pulse.enable = true;
      jack.enable = true;
      alsa.enable = true;
      wireplumber.enable = true;
    };
  };
}
