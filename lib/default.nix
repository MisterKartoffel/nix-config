{ lib }:
let
  files = builtins.attrNames (removeAttrs (builtins.readDir ./.) [ "default.nix" ]);
in
builtins.foldl' (acc: file: acc // import (./. + "/${file}") { inherit lib; }) { } files
