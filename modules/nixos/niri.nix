{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.programs) niri;
in
{
  config = lib.mkIf niri.enable {
    programs.niri.useNautilus = false;

    xdg.portal = {
      xdgOpenUsePortal = true;
      extraPortals = builtins.attrValues { inherit (pkgs) xdg-desktop-portal-gtk; };
    };
  };
}
