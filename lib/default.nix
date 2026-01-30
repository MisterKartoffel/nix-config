{ lib }:
let
  files = builtins.attrNames (builtins.removeAttrs (builtins.readDir ./.) [ "default.nix" ]);
  toImport = map (file: import (./. + "/${file}") { inherit lib; }) files;
in
lib.foldl' lib.mergeAttrs { } toImport
