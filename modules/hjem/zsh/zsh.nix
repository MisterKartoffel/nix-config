{
  osConfig,
  config,
  lib,
  ...
}:
let
  inherit (osConfig.programs) zsh;

  xdg.config = config.xdg.config.directory;

  files = [
    "aliases"
    "completion"
    "environment"
    "options"
    "plugins"
  ];
in
{
  files.".zshrc" = {
    inherit (zsh) enable;
    executable = true;

    text = lib.concatMapStringsSep "\n" (file: "source ${xdg.config}/zsh/${file}") files;
  };
}
