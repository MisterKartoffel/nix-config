{ pkgs, lib, ... }:
let
  wallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/orangci/walls-catppuccin-mocha/master/paint.jpg";
    hash = "sha256-9/4PtVNTvT+qILYcp+5Dir7VWXox2zbp0DuXkTv/ecU=";
  };
in
{
  systemd.user.services.swaybg = {
    Unit = {
      Description = "Swaybg background image service";
      Documentation = "man:swaybg(1)";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      Requisite = [ "graphical-session.target" ];
    };

    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${lib.getExe pkgs.swaybg} -i ${wallpaper}";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
