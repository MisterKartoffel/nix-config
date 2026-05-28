{ config, ... }:
let
  inherit (config.programs) nvf ghostty;
in
{
  accounts = {
    email.accounts = {
      hotmail.enable = true;
      ufrgs.enable = true;
    };
  };

  programs = {
    eza.enable = true;
    ghostty.enable = true;
    git.enable = true;
    nvf.enable = true;
    nh.enable = true;
    ssh.enable = true;
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
