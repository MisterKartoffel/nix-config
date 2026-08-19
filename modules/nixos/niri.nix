{
  config,
  lib,
  ...
}:
let
  inherit (config.programs) niri;
in
{
  config = lib.mkIf niri.enable {
    programs.niri.useNautilus = false;
    xdg.portal.xdgOpenUsePortal = true;
  };
}
