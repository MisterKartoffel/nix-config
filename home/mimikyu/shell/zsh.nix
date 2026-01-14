{ config, lib, ... }: {
	programs.zsh = {
		enable = true;

		autocd = true;
		defaultKeymap = "viins";
		dotDir = "${config.xdg.configHome}/zsh";

		autosuggestion.enable = true;
		enableCompletion = true;

		completionInit = ''
			autoload -Uz compinit
			compinit -C -d ${config.xdg.cacheHome}/zsh-zcompdump-$ZSH_VERSION
		'';

		syntaxHighlighting.enable = true;

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

		loginExtra = ''
			{
				setopt LOCAL_OPTIONS EXTENDED_GLOB
				autoload -U zrecompile

				zrecompile -pq "$ZDOTDIR/.zshenv" -- \
											 "$ZDOTDIR/.zprofile" -- \
											 "$ZDOTDIR/.zshrc" -- \
											 "$ZDOTDIR/.zlogin" -- \
											 "$ZDOTDIR/.zlogout"
			} &!
		'';

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
				'';
				zshExtraConfigLast = lib.mkAfter ''
				'';
			in
				lib.mkMerge [ zshExtraConfigEarlyInit zshExtraConfig zshExtraConfigLast ];
	};
}
