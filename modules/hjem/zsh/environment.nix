{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (osConfig.programs) zsh;

  xdg = {
    cache = config.xdg.cache.directory;
    config = config.xdg.config.directory;
    data = config.xdg.data.directory;
    state = config.xdg.state.directory;
  };
in
{
  xdg.config.files."zsh/environment" = {
    inherit (zsh) enable;
    executable = true;

    text = ''
      # XDG Base Directories
      export XDG_CACHE_HOME="${xdg.cache}"
      export XDG_CONFIG_HOME="${xdg.config}"
      export XDG_DATA_HOME="${xdg.data}"
      export XDG_STATE_HOME="${xdg.state}"

      # XDG Base Directory compliance
      export CARGO_HOME="${xdg.data}/cargo" # Rust Cargo
      export POWERLEVEL9K_CONFIG_FILE="${xdg.config}/zsh/p10k.zsh"
      export PYTHON_HISTORY="${xdg.state}/python_history"
      export PYTHONPYCACHEPREFIX="${xdg.cache}/python"
      export PYTHONUSERBASE="${xdg.data}/python"
      export W3M_DIR="${xdg.state}/w3m"
      export XCURSOR_PATH="${xdg.data}/icons" # Xcursor themes

      # run0 variables
      export SYSTEMD_RUN_SHELL_PROMPT_PREFIX="run0 "
      export SYSTEMD_ADJUST_TERMINAL_TITLE="false"
      export SYSTEMD_TINT_BACKGROUND="false"

      # Colors
      source <(${lib.getExe' pkgs.coreutils "dircolors"})
      export FZF_DEFAULT_OPTS=" \
      --color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
      --color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
      --color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
      --color=selected-bg:#45475A,border:#6C7086,label:#CDD6F4"
    '';
  };
}
