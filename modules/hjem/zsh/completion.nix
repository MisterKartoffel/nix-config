{ osConfig, config, ... }:
let
  inherit (osConfig.programs) zsh;

  xdg = {
    cache = config.xdg.cache.directory;
    state = config.xdg.state.directory;
  };
in
{
  xdg.config.files."zsh/completion" = {
    inherit (zsh) enable;
    executable = true;

    text = ''
      zstyle ":completion:*" use-cache on
      zstyle ":completion:*" cache-path "${xdg.cache}/zsh/zcompcache"
      zstyle ":completion:*:functions" ignored-patterns "_*"
      zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"
      zstyle ":completion:*:descriptions" format "[%d]"
      zstyle ":completion:*" menu no

      autoload -Uz compinit
      compinit -C -d "${xdg.state}/zsh/completion"
    '';
  };
}
