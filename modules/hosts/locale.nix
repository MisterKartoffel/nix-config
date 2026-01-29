{ config, ... }:
{
  time.timeZone = "America/Sao_Paulo";

  console.keyMap = "br-abnt2";

  i18n = {
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.waylandFrontend = true;
    };

    defaultLocale = config.modules.system.locale.language;
    extraLocaleSettings = config.modules.system.locale.overrides;
  };

  environment.sessionVariables = {
    QT_IM_MODULE = "fcitx";
    SDL_IM_MODULE = "fcitx";
  };
}
