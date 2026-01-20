{ config, ... }:
let
  Home = config.home.homeDirectory;
in
{
  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    desktop = "${Home}/Desktop";
    download = "${Home}/Downloads";
    music = "${Home}/Music";
    pictures = "${Home}/Pictures";
    publicShare = "${Home}/Public";
    templates = "${Home}/Templates";
    videos = "${Home}/Videos";
  };
}
