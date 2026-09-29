{ lib }:
let
  overlays = final: prev: {
    additions = { };

    linuxOverlays = lib.optionalAttrs prev.stdenv.hostPlatform.isLinux { };

    overlays = {
      bibata-cursors = prev.bibata-cursors.overrideAttrs (_: {
        buildPhase = ''
          runHook preBuild
          ctgen configs/normal/x.build.toml -p x11 -d $bitmaps/Bibata-Modern-Ice -n 'Bibata-Modern-Ice' -c 'White and rounded edge Bibata XCursors'
          runHook postBuild
        '';
      });

      magnetic-catppuccin-gtk = prev.magnetic-catppuccin-gtk.override {
        accent = [ "mauve" ];
      };

      catppuccin-kvantum = prev.catppuccin-kvantum.override {
        variant = "mocha";
        accent = "mauve";
      };

      catppuccin-zen = final.fetchFromGitHub {
        owner = "catppuccin";
        repo = "zen-browser";
        rev = "c855685442c6040c4dda9c8d3ddc7b708de1cbaa";
        hash = "sha256-5A57Lyctq497SSph7B+ucuEyF1gGVTsuI3zuBItGfg4=";
      };
    };
  };
in
final: prev: lib.mergeAttrsList (builtins.attrValues (overlays final prev))
