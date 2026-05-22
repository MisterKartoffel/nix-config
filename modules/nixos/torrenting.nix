{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.services) qbittorrent;
in
{
  services.qbittorrent = lib.mkIf qbittorrent.enable {
    openFirewall = true;
    serverConfig = {
      Preferences = {
        WebUI = {
          AlternativeUIEnabled = true;
          RootFolder = "${pkgs.vuetorrent}/share/vuetorrent";
        };
      };
    };
  };
}
