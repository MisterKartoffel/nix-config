{ lib }:
let
  inherit (lib) hasPrefix hasSuffix;
  inherit (lib.filesystem) listFilesRecursive;
  relativeToRoot = lib.path.append ../.;
in
{
  inherit relativeToRoot;

  makeImport =
    path:
    builtins.filter (file: hasSuffix ".nix" file && !(hasPrefix "_" (baseNameOf file))) (
      listFilesRecursive (relativeToRoot path)
    );
}
