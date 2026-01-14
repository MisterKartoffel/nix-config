{ inputs, pkgs, ... }:
let
	wallpaper = pkgs.fetchurl {
		url = "https://raw.githubusercontent.com/orangci/walls-catppuccin-mocha/master/paint.jpg";
		hash = "sha256-9/4PtVNTvT+qILYcp+5Dir7VWXox2zbp0DuXkTv/ecU=";
	};
in {
	imports = [ inputs.stylix.homeModules.stylix ];
	home.packages = with pkgs; [ swaybg ];
	
	systemd.user.services.swaybg = {
		Unit = {
			Description = "Swaybg background image service";
			Documentation = "man:swaybg(1)";
			PartOf = [ "graphical-session.target" ];
			After = [ "graphical-session.target" ];
			Requisite = [ "graphical-session.target" ];
		};

		Service = {
			Type = "oneshot";
			RemainAfterExit = true;
			ExecStart = "${pkgs.swaybg}/bin/swaybg -i ${wallpaper}";
		};

		Install.WantedBy = [ "graphical-session.target" ];
	};

	stylix = {
		enable = true;

		targets = {
			nvf.enable = false;
			zen-browser.profileNames = [ "Profile0" ];
		};

		base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

		cursor = {
			package = pkgs.bibata-cursors;
			name = "Bibata-Modern-Ice";
			size = 24;
		};

		fonts = {
			monospace = {
				package = pkgs.commit-mono;
				name = "Commit Mono";
			};
		};
	};
}
