{ lib, ... }:
let
  overlays = _final: prev: {
    additions = { };
    linuxOverlays = lib.optionalAttrs prev.stdenv.isLinux { };
    overlays = { };
  };
in
{
  default = final: prev: lib.mergeAttrsList (builtins.attrValues (overlays final prev));
}
