{ lib }:
builtins.foldl'
  (
    acc: file:
    builtins.foldl' (
      acc': function:
      if builtins.hasAttr function acc' then
        throw "lib: duplicate function '${function}'"
      else
        acc' // { ${function} = file.${function}; }
    ) acc (builtins.attrNames file)
  )
  { }
  (
    map (file: import ./${file} { inherit lib; }) (
      builtins.attrNames (removeAttrs (builtins.readDir ./.) [ "default.nix" ])
    )
  )
