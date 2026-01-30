{ lib }:
{
  relativeToRoot = lib.path.append ../.;

  importSelf =
    dir:
    let
      entries = builtins.readDir dir;

      files = lib.filter (name: lib.hasSuffix ".nix" name && name != "default.nix") (
        lib.attrNames entries
      );

      directories = lib.filter (name: entries.${name} == "directory") (lib.attrNames entries);
    in
    map (name: dir + "/${name}") (files ++ directories);
}
