{ pkgs, ... }: {
	imports = [
		./graphical
		./shell
		./neovim
		./cli

		./environment.nix
		./sops.nix
		./stylix.nix
		./xdg.nix
	];

	home.packages = with pkgs; [ git ];
}
