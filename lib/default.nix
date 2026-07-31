/*
  To get functions from lib/ into scope for other modules in
  the form of lib.custom, add the following extension to flake.nix,
  then inherit lib in nixpkgs.lib.nixosSystem:

  lib = nixpkgs.lib.extend (_: prev: { custom = import ./lib { lib = prev; }; });
*/

{ lib }:
let
  files = map (file: import ./${file} { inherit lib; }) (
    builtins.filter (file: file != "default.nix") (builtins.attrNames (builtins.readDir ./.))
  );
in
builtins.zipAttrsWith (
  name: values:
  if builtins.length values > 1 then
    throw "lib: duplicate function '${name}'"
  else
    builtins.head values
) files
