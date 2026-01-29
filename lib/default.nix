{ lib }:
let
  files = builtins.attrNames (builtins.removeAttrs (builtins.readDir ./.) [ "default.nix" ]);
  imported = map (name: import (./. + "/${name}") { inherit lib; }) files;
in
lib.foldl' lib.mergeAttrs { } imported
