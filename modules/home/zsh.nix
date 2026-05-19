{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.zsh;
in
{
  programs.zsh = lib.mkIf cfg.enable {
    autocd = true;
    defaultKeymap = "viins";
    dotDir = "${config.xdg.configHome}/zsh";

    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    completionInit = ''
      autoload -Uz compinit
      compinit -C -d ${config.xdg.cacheHome}/zsh-zcompdump-$ZSH_VERSION
    '';

    history = {
      append = true;
      share = true;
      expireDuplicatesFirst = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      path = "${config.xdg.stateHome}/zsh/history";
      size = 10000;
    };

    setOptions = [
      "GLOB_DOTS"
      "NO_CLOBBER"
    ];

    initContent =
      let
        zshExtraConfigEarlyInit = lib.mkBefore ''
          zstyle ":completion:*" use-cache on
          zstyle ":completion:*" cache-path "${config.xdg.cacheHome}/zsh/zcompcache"
          zstyle ":completion:*:functions" ignored-patterns "_*"
          zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"
          zstyle ":completion:*:descriptions" format "[%d]"
          zstyle ":completion:*" menu no
        '';
        zshExtraConfig = ''
          [[ -f ${config.programs.zsh.dotDir}/.p10k.zsh ]] && source ${config.programs.zsh.dotDir}/.p10k.zsh
        '';
        zshExtraConfigLast = lib.mkAfter "";
      in
      lib.mkMerge [
        zshExtraConfigEarlyInit
        zshExtraConfig
        zshExtraConfigLast
      ];
  };
}
