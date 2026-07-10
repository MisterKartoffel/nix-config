{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config) stylix;
in
{
  imports = [ inputs.stylix.homeModules.stylix ];

  stylix = lib.mkIf stylix.enable {
    targets = {
      nvf.enable = false;
      zen-browser.profileNames = [ "Profile0" ];
    };

    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/orangci/walls-catppuccin-mocha/refs/heads/master/cat-vibin.png";
      hash = "sha256-ERZ4sAGhkaBM/tMBPfxeY5dF6xs61i9xXy1z/ovtJr8=";
    };

    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    fonts = {
      serif = {
        package = pkgs.freefont_ttf;
        name = "FreeSerif";
      };

      sansSerif = {
        package = pkgs.freefont_ttf;
        name = "FreeSans";
      };

      monospace = {
        package = pkgs.nerd-fonts.commit-mono;
        name = "Commit Mono Nerd Font";
      };

      sizes = {
        desktop = 12;
        terminal = 16;
      };
    };

    # stylix: incompatible with home-manager.useGlobalPkgs
    # https://github.com/nix-community/stylix/issues/1832
    overlays.enable = false;
  };

  fonts.fontconfig.enable = true;
}
