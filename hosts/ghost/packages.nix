{
  programs = {
    zsh.enable = true;
    dconf.enable = true;
  };

  environment.pathsToLink = [ "/share/zsh" ];

  security.pam.services.login.enableGnomeKeyring = true;
}
