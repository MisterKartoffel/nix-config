{ lib }:
let
  files = builtins.attrNames (builtins.removeAttrs (builtins.readDir ./.) [ "default.nix" ]);
in
builtins.foldl' (acc: file: acc // import (./. + "/${file}") { inherit lib; }) { } files
