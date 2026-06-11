{ lib }:
let
  inherit (lib) foldlAttrs recursiveUpdate splitString;
  inherit (lib.attrsets) setAttrByPath;
in
{
  nestAttrset =
    attrset:
    foldlAttrs (
      acc: path: value:
      recursiveUpdate acc (setAttrByPath (splitString "/" path) value)
    ) { } attrset;
}
