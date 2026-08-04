{ lib }:
let
  contents = builtins.readDir ../.;
  isRuntime = name: type: type == "directory" && name != "nix";
in
map (name: ../${name}) (builtins.attrNames (lib.filterAttrs isRuntime contents))
