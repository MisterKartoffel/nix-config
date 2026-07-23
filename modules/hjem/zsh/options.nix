{
  osConfig,
  config,
  lib,
  ...
}:
let
  inherit (osConfig.programs) zsh;

  xdg = {
    config = config.xdg.config.directory;
    state = config.xdg.state.directory;
  };

  options = [
    "APPEND_HISTORY"
    "AUTOCD"
    "GLOB_DOTS"
    "HIST_EXPIRE_DUPS_FIRST"
    "HIST_FCNTL_LOCK"
    "HIST_IGNORE_ALL_DUPS"
    "HIST_IGNORE_DUPS"
    "HIST_IGNORE_SPACE"
    "NO_CLOBBER"
    "NO_EXTENDED_HISTORY"
    "NO_HIST_FIND_NO_DUPS"
    "NO_HIST_SAVE_NO_DUPS"
    "SHARE_HISTORY"
  ];
in
{
  xdg.config.files."zsh/options" = {
    inherit (zsh) enable;
    executable = true;

    text = ''
      HISTFILE=${xdg.state}/zsh/history
      HISTSIZE=10000
      SAVEHIST=$HISTSIZE
      HISTDUP=erase
    ''
    + lib.concatMapStringsSep "\n" (option: "setopt ${option}") options;
  };
}
