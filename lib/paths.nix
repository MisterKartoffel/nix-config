{ lib }:
{
  relativeToRoot = lib.path.append ../.;

  importPaths =
    dirs:
    lib.concatMap (
      dir:
      map (name: dir + "/${name}") (
        lib.filter (name: lib.hasSuffix ".nix" name && name != "default.nix") (
          lib.attrNames (builtins.readDir dir)
        )
      )
    ) dirs;
}
