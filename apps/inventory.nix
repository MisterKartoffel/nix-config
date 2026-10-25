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
