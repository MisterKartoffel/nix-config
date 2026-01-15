{
	hostSpec = {
		hostname = "ghost";
		stateVersion = "25.11";
		systemArch = "x86_64-linux";
		flakeRoot = "/home/mimikyu/nix-config";

		userList = [
			{
				name = "mimikyu";
				shell = "zsh";
				extraGroups = [ "wheel" "video" ];
				extraModules = [
					../../home/mimikyu
					../../home/common/optional/desktop
					../../home/common/optional/theming
					../../home/common/optional/neovim
				];
			}
		];
	};
}
