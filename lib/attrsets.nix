{ lib }:
let
  inherit (lib)
    concatStringsSep
    mapAttrsToList
    recursiveUpdateUntil
    setAttrByPath
    splitString
    ;
in
{
  nestAttrset =
    attrset:
    builtins.foldl' (recursiveUpdateUntil (
      path: left: right:
      if !(builtins.isAttrs left && builtins.isAttrs right) then
        throw ''
          Conflict at path '${concatStringsSep "." path}'.
          Cannot merge duplicate leaves.
          	- ${builtins.toJSON left}
          	- ${builtins.toJSON right}
        ''
      else
        false
    )) { } (mapAttrsToList (key: value: setAttrByPath (splitString "/" key) value) attrset);
}
