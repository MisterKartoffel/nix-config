{ config, lib, ... }:
let
  inherit (config.programs) nvf ghostty zen-browser;
in
{
  imports = map lib.custom.relativeToRoot (
    [
      "modules/home/core"
    ]
    ++ (map (file: "modules/home/optional/${file}") [
      "desktop"
      "mail"
      "neovim"
      "theming"
    ])
  );

  home.sessionVariables = {
    EDITOR = if nvf.enable then "nvim" else "nano";
    VISUAL = if nvf.enable then "nvim" else "nano";
    BROWSER = if zen-browser.enable then "zen" else "";
    TERMINAL = if ghostty.enable then "ghostty" else "";
    MANPAGER = if nvf.enable then "nvim +Man!" else "";
  };
}
