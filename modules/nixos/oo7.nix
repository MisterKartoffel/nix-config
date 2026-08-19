{ config, lib, ... }:
let
  inherit (config.services) oo7;
in
{
  services.gnome.gnome-keyring.enable = !oo7.enable;
  security.pam.services.passwd.oo7.enable = lib.mkDefault oo7.enable;

  xdg.portal.config.niri."org.freedesktop.impl.portal.Secret" = lib.mkIf oo7.enable (
    lib.mkForce "oo7-portal"
  );
}
