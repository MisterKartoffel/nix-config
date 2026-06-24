{
  inputs ? import ./.tack,
  system,
  mkShell,
}:
let
  inherit (inputs.tack.packages.${system}) tack;
in
mkShell {
  packages = [ tack ];
}
