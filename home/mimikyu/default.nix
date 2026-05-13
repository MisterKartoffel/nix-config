{
  config,
  lib,
  ...
}:
let
  inherit (config.programs) nvf ghostty;
in
{
  imports = lib.custom.makeImport "modules/home-manager";

  home.sessionVariables = {
    TERMINAL = if ghostty.enable then "ghostty" else "";
    MANPAGER = if nvf.enable then "nvim +Man!" else "";
  };
}
