{
  osConfig,
  pkgs,
  lib,
  ...
}:
let
  inherit (osConfig.programs) zsh;
in
{
  xdg.config.files."zsh/aliases" = {
    inherit (zsh) enable;
    executable = true;

    text = ''
      alias ls="${lib.getExe pkgs.eza} --long --icons=always --color=always --git --group-directories-first"
    '';
  };
}
