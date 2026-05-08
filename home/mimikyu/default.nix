{
  config,
  lib,
  ...
}:
let
  inherit (config.programs) nvf ghostty;
in
{
  imports = map lib.custom.relativeToRoot (
    [
      "home/common/core"
    ]
    ++ (map (file: "home/common/optional/${file}") [
      "desktop"
      "mail"
      "neovim"
      "theming"
    ])
  );

  home.sessionVariables = {
    TERMINAL = if ghostty.enable then "ghostty" else "";
    MANPAGER = if nvf.enable then "nvim +Man!" else "";
  };
}
