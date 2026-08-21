{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (inputs.basix.schemeData.base24.catppuccin-mocha) palette;
  inherit (inputs.vellum.packages.${pkgs.stdenv.hostPlatform.system}) vellum;
in
{
  xdg.config.files."vellum/config.toml" = {
    generator = (pkgs.formats.toml { }).generate "vellum-config.toml";
    value = {
      remember_last_tool = false;
      palette = builtins.attrValues {
        inherit (palette)
          base08
          base09
          base0A
          base0B
          base0D
          base0E
          base05
          base00
          ;
      };
    };
  };

  systemd.services.vellum = {
    description = "Vellum screen annotation overlay";
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    restartTriggers = [ config.xdg.config.files."vellum/config.toml".source ];

    serviceConfig = {
      Type = "exec";
      ExecStart = lib.getExe' vellum "vellum";
      Restart = "on-failure";
    };
  };
}
