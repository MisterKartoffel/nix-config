{ pkgs }:
pkgs.mkShell {
  packages = builtins.attrValues { inherit (pkgs) just; };
}
