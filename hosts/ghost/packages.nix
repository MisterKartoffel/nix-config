{
  programs = {
    zsh.enable = true;
    dconf.enable = true;
  };

  security.pam.services.login.enableGnomeKeyring = true;
}
