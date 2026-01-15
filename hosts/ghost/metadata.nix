{
	hostSpec = {
		hostname = "ghost";
		system = "x86_64-linux";
		stateVersion = "25.11";
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
