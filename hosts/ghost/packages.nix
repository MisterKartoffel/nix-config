{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ sops ];

  programs = {
    zsh.enable = true;
    dconf.enable = true;
  };
}
