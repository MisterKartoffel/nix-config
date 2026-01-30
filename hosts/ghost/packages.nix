{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    sops
    libsecret
    nh
  ];

  programs = {
    zsh.enable = true;
    dconf.enable = true;
  };

  security.pam.services.login.enableGnomeKeyring = true;
}
