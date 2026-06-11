{
  inputs,
  pkgs,
  system,
}:
let
  inherit (inputs.tack.packages.${system}) tack;
in
pkgs.mkShell {
  packages = builtins.attrValues {
    inherit tack;
    inherit (pkgs) just;
  };
}
