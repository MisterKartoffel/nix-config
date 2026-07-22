{ pkgs, lib, ... }:
let
  wallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/orangci/walls-catppuccin-mocha/refs/heads/master/cat-vibin.png";
    hash = "sha256-ERZ4sAGhkaBM/tMBPfxeY5dF6xs61i9xXy1z/ovtJr8=";
  };
in
{
  systemd.services.swaybg = {
    description = "Swaybg background image service";
    documentation = [ "man:swaybg(1)" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    requisite = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${lib.getExe pkgs.swaybg} -i ${wallpaper}";
    };
  };
}
