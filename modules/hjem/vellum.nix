{
  config,
  pkgs,
  lib,
  ...
}:
{
  packages = builtins.attrValues { inherit (pkgs) vellum; };

  xdg.config.files."vellum/config.toml" = {
    generator = (pkgs.formats.toml { }).generate "vellum-config.toml";
    value = {
      remember_last_tool = false;
      clear_on_escape = true;
      palette = [
        "#f38ba8"
        "#fab387"
        "#f9e2af"
        "#a6e3a1"
        "#89b4fa"
        "#cba6f7"
        "#cdd6f4"
        "#1e1e2e"
      ];
    };
  };

  systemd.services.vellum = {
    description = "Vellum screen annotation overlay";
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    restartTriggers = [ (config.xdg.config.files."vellum/config.toml".source or null) ];

    serviceConfig = {
      Type = "exec";
      ExecStart = lib.getExe pkgs.vellum;
      Restart = "on-failure";
    };
  };
}
