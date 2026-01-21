{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    sops
    libsecret
  ];

  programs = {
    zsh.enable = true;
    dconf.enable = true;
  };

  security.pam.services.login.enableGnomeKeyring = true;
}
