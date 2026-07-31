{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShellNoCC {
  packages = builtins.attrValues {
    inherit (pkgs)
      tack

      nil
      lua-language-server
      ;
  };
}
