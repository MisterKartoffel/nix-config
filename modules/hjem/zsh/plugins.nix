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
    config = config.xdg.config.directory;
    projects = "${config.directory}/Projects";
  };

  plugins = [
    "${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh"
    "${pkgs.zsh-autosuggestions}/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
    "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
    "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme"

    # Integrations
    "${xdg.config}/zsh/fzf"
  ];
in
{
  packages = builtins.attrValues { inherit (pkgs) fzf nix-zsh-completions; };

  xdg.config.files."zsh/plugins" = {
    inherit (zsh) enable;
    executable = true;

    text = ''
      [[ -f ${xdg.config}/zsh/.p10k.zsh ]] && source ${xdg.config}/zsh/.p10k.zsh
    ''
    + lib.concatMapStringsSep "\n" (plugin: "source ${plugin}") plugins;
  };

  xdg.config.files."zsh/fzf" = {
    inherit (zsh) enable;
    executable = true;

    text = ''
      source <(fzf --zsh)

      export FZF_ALT_C_OPTS="
        --style full
        --preview '${lib.getExe pkgs.eza} --all --icons=always --color=always --group-directories-first --tree --level 1 {}'
        --preview-window '70%'
        --bind 'backward-eof:abort'
      "

      export FZF_CTRL_T_COMMAND="${lib.getExe pkgs.fd} --type file --base-directory ${xdg.projects} --exclude .git --exclude .direnv"
      export FZF_CTRL_T_OPTS="
        --style full
        --preview '[[ -f ${xdg.projects}/{} ]] && ${lib.getExe' pkgs.coreutils "cat"} --number ${xdg.projects}/{}; [[ -d ${xdg.projects}/{} ]] && ${lib.getExe pkgs.eza} --all --icons=always --color=always --tree --level 1 ${xdg.projects}/{}'
        --bind 'backward-eof:abort'
      "

      export FZF_CTRL_R_OPTS="
        --style full
        --reverse
        --preview 'echo {}'
        --preview-window down:3:hidden:wrap
        --bind '?:toggle-preview'
        --bind 'backward-eof:abort'
      "
    '';
  };
}
