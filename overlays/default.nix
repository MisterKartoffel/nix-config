{ lib, ... }:
let
  overlays = {
    # Custom packages.
    additions = final: prev: { };

    # Overlays exclusive to Linux systems.
    linuxOverlays = final: prev: lib.optionalAttrs prev.stdenv.isLinux ({ });

    # General overlays.
    overlays = final: prev: { };
  };
in
{
  default =
    final: prev:
    lib.pipe overlays [
      (builtins.attrNames)
      (map (name: (overlays.${name} final prev)))
      (lib.mergeAttrsList)
    ];
}
