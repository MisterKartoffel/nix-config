{ config, lib, ... }:
let
	inherit (config.custom) graphical;
in {
	config = lib.mkIf graphical.enable {
		services.dunst.enable = true;
	};
}
