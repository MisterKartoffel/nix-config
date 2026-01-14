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
				extraModules = [ ../../home/mimikyu ];
			}
		];
	};
}
