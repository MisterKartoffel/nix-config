{ config, lib, ... }:
let
  inherit (lib) mkIf;
  cfg = config.modules.services.pipewire;
in
{
  config = mkIf cfg.enable {
    services = {
      pulseaudio.enable = lib.mkForce false;

      pipewire = {
        enable = true;
        pulse.enable = true;
        jack.enable = true;
        alsa.enable = true;
        wireplumber.enable = true;
      };
    };
  };
}
