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
				homeModule = ../../home/mimikyu;
				extraGroups = [ "wheel" "video" ];
			}
		];
	};
}
