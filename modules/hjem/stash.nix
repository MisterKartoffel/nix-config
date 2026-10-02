{ pkgs, lib, ... }:
{
  packages = builtins.attrValues { inherit (pkgs) stash-clipboard; };

  systemd.services.stash-clipboard = {
    description = "Wayland clipboard manager with fast persistent history and multi-media support";
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    requisite = [ "graphical-session.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${lib.getExe pkgs.stash-clipboard} watch --persist";
      Restart = "on-failure";
    };
  };
}
