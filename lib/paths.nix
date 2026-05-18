{ lib }:
let
  inherit (lib) hasPrefix;
  inherit (lib.fileset) toList fileFilter;

  relativeToRoot = lib.path.append ../.;
in
{
  inherit relativeToRoot;

  importTree =
    path:
    toList (fileFilter (file: file.hasExt "nix" && !(hasPrefix "_" file.name)) (relativeToRoot path));
}
