{ config, lib, ... }:
let
  cfg = config.services.pipewire;
in
{
  services = lib.mkIf cfg.enable {
    pulseaudio.enable = lib.mkForce false;

    pipewire = {
      pulse.enable = true;
      jack.enable = true;
      alsa.enable = true;
      wireplumber.enable = true;
    };
  };
}
