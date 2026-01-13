{ pkgs, ... }: {
	programs.fuzzel = {
		enable = true;
		settings = {
			main = {
				use-bold = true;
				terminal = "${pkgs.ghostty}/bin/ghostty";
			};
		};
	};
}
