{ pkgsFor ? null, ...}:
let
	hostSpec = {
		hostname = "ghost";
		stateVersion = "25.11";
		systemArch = "x86_64-linux";
		flakeRoot = "/home/mimikyu/nix-config";
	};

	pkgs = pkgsFor hostSpec.systemArch;
in {
		hostSpec = hostSpec // {
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
