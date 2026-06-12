{ lib }:
let
  files = builtins.attrNames (removeAttrs (builtins.readDir ./.) [ "default.nix" ]);
in
builtins.foldl' (
  acc: file:
  let
    set = import ./${file} { inherit lib; };
  in
  builtins.foldl' (
    acc': name:
    if builtins.hasAttr name acc' then
      throw "Duplicate function: '${name}'"
    else
      acc' // { ${name} = set.${name}; }
  ) acc (builtins.attrNames set)
) { } files
