{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (osConfig.programs) zsh;

  xdg.config = config.xdg.config.directory;

  plugins = [
    "${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh"
    "${pkgs.zsh-autosuggestions}/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
    "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
    "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme"
  ];
in
{
  packages = builtins.attrValues { inherit (pkgs) nix-zsh-completions; };

  xdg.config.files."zsh/plugins" = {
    inherit (zsh) enable;
    executable = true;

    text = ''
      [[ -f ${xdg.config}/zsh/.p10k.zsh ]] && source ${xdg.config}/zsh/.p10k.zsh
    ''
    + lib.concatMapStringsSep "\n" (plugin: "source ${plugin}") plugins;
  };
}
