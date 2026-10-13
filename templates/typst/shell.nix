{
  # keep-sorted start

  mkShellNoCC,
  nil,
  tack,
  tinymist,
  typst,

  # keep-sorted end
}:
mkShellNoCC {
  name = "typst";

  packages = builtins.attrValues {
    inherit
      # keep-sorted start

      nil
      tack
      tinymist

      # keep-sorted end
      ;
  };

  strictDeps = true;
  nativeBuildInputs = [
    (typst.withPackages (_packages: builtins.attrValues { }))
  ];
}
