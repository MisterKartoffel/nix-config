{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings.default_session.command = lib.getExe pkgs.tuigreet;
  };

  environment.etc."tuigreet/config.toml".source =
    (pkgs.formats.toml { }).generate "tuigreet-config.toml"
      {
        general.numlock = true;

        session.sessions_dirs = [
          "${config.services.displayManager.sessionData.desktops}/share/wayland-sessions"
        ];

        remember = {
          username = true;
          user_session = true;
        };

        user_menu.enable = true;
        secret.mode = "characters";
      };
}
