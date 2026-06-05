{
  pkgs ? import <nixpkgs> { },
}:
{
  default = pkgs.mkShell {
    packages = builtins.attrValues { inherit (pkgs) just; };
  };
}
