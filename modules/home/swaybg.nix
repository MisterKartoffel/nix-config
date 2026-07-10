{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config) stylix;
in
{
  systemd.user.services.swaybg = lib.mkIf stylix.enable {
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
      ExecStart = "${lib.getExe pkgs.swaybg} -i ${stylix.image}";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
