{ pkgs, ... }:
{
  services.qbittorrent = {
    enable = false;
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
