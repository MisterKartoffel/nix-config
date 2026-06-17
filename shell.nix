{
  inputs ? import ./.tack,
  system ? builtins.currentSystem,
  mkShell,
  just,
}:
let
  inherit (inputs.tack.packages.${system}) tack;
in
mkShell {
  packages = builtins.attrValues {
    inherit just tack;
  };
}
