{ config, lib, ... }:
let
	inherit (config.custom) graphical;
in {
	config = lib.mkIf graphical.enable {
		programs.tofi = {
			enable = true;

			settings = {
				font = "Commit Mono";
				font-size = lib.mkForce "24";

				num-results = 5;
				result-spacing = 25;

				width = "100%";
				height = "100%";
				outline-width = 0;
				border-width = 0;
				padding-top = "35%";
				padding-left = "35%";

				hide-cursor = true;
				history = true;
				fuzzy-match = true;
				drun-launch = true;
			};
		};
	};
}
