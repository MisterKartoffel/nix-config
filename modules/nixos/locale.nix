{
  i18n = {
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.waylandFrontend = true;
    };

    extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };
  };

  environment.sessionVariables = {
    QT_IM_MODULE = "fcitx";
    SDL_IM_MODULE = "fcitx";
  };
}
