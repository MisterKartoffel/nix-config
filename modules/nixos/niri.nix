{ config, ... }:
let
  inherit (config.programs) niri;
in
{
  programs.niri.useNautilus = false;
  xdg.portal.xdgOpenUsePortal = niri.enable;
}
