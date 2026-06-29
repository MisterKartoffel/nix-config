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
