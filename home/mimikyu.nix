{ config, ... }:
let
  inherit (config.programs) nvf ghostty;
in
{
  programs = {
    eza.enable = true;
    ghostty.enable = true;
    nvf.enable = true;
    nh.enable = true;
    tofi.enable = true;
    vesktop.enable = true;
    zen-browser.enable = true;
    zsh.enable = true;
  };

  services = {
    dunst.enable = true;
    playerctld.enable = true;
  };

  stylix.enable = true;

  home.sessionVariables = {
    TERMINAL = if ghostty.enable then "ghostty" else "";
    MANPAGER = if nvf.enable then "nvim +Man!" else "";
  };
}
