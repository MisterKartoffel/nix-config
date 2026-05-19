{
  config,
  lib,
  ...
}:
let
  inherit (config.programs) nvf ghostty;
in
{
  imports = lib.custom.importTree "modules/home" ++ [ ./impermanence.nix ];

  programs = {
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
  };

  stylix.enable = true;

  home = {
    persistence."/etc/persist".enable = true;

    sessionVariables = {
      TERMINAL = if ghostty.enable then "ghostty" else "";
      MANPAGER = if nvf.enable then "nvim +Man!" else "";
    };
  };
}
