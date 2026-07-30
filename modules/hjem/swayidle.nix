{ pkgs, lib, ... }: {
  systemd.services.swayidle = {
    description = "Idle manager for Wayland";
    documentation = [ "man:swayidle(1)" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];

    unitConfig.ConditionEnvironment = "WAYLAND_DISPLAY";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${lib.getExe pkgs.swayidle} -w idlehint 300";
      Restart = "on-failure";
    };
  };
}
