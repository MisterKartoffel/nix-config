# Inspired by the work done by wimpysworld in:
# https://github.com/wimpysworld/nix-config/blob/main/home-manager/_mixins/scripts/flake-inventory/flake-inventory.sh
{
  # keep-sorted start

  jq,
  lib,
  nix,
  writers,

  # keep-sorted end
}:
writers.writeNuBin "inventory.nu"
  {
    makeWrapperArgs = [
      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath [
        jq
        nix
      ])
    ];
  }
  ''
    ${builtins.readFile ../ci/inventory.nu}
  ''
