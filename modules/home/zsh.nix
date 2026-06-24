{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.programs) fzf;
in
{
  programs.zsh = {
    autocd = true;
    defaultKeymap = "viins";

    autosuggestion.enable = true;
    enableCompletion = true;
    fastSyntaxHighlighting.enable = true;

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ]
    ++ lib.optionals fzf.enable [
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab.src;
      }
    ];

    completionInit = ''
      autoload -Uz compinit
      compinit -C -d ${config.xdg.cacheHome}/zsh-zcompdump-$ZSH_VERSION
    '';

    history = {
      append = true;
      expireDuplicatesFirst = true;
      ignoreAllDups = true;
      path = "${config.xdg.stateHome}/zsh/history";
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
        zshExtraConfigLast = lib.mkAfter ''
          autoload -Uz edit-command-line
          zle -N edit-command-line
          bindkey "^[e" edit-command-line

          bindkey " " magic-space
        '';
      in
      lib.mkMerge [
        zshExtraConfigEarlyInit
        zshExtraConfig
        zshExtraConfigLast
      ];
  };
}
