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
				shell = pkgs.zsh;
				extraGroups = [ "wheel" "video" ];
				extraModules = [ ../../home/mimikyu ];
				authorizedKeyFiles = let
					keyDir = builtins.path { path = ../../home/mimikyu/keys; };
				in 
					map (file: "${keyDir}/${file}")
						(builtins.attrNames (builtins.readDir keyDir));
			}
		];
	};
}
