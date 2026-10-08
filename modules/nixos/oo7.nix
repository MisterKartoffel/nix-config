{ config, lib, ... }:
let
  inherit (config.services) greetd oo7;
in
{
  config = lib.mkIf oo7.enable {
    services.gnome.gnome-keyring.enable = false;

    security.pam.services = {
      passwd.oo7.enable = true;
      greetd.oo7.enable = greetd.enable;
    };

    xdg.portal.config.niri."org.freedesktop.impl.portal.Secret" = lib.mkForce "oo7-portal";
  };
}
