{ pkgsFor ? null, ...}:
let
	host = {
		hostname = "ghost";
		stateVersion = "25.11";
		systemArch = "x86_64-linux";
		flakeRoot = "/home/mimikyu/nix-config";
	};

	pkgs = pkgsFor host.systemArch;
in {
		host = host // {
			userList = [
				{
					name = "mimikyu";
					description = "Felipe Duarte";
					email = "felipesdrs@hotmail.com";
					shell = pkgs.zsh;
					passwordKey = "mimikyu/password";
					extraGroups = [ "wheel" "video" ];
					extraModules = [ ../../home/mimikyu ];
				}
			];
		};
}
