{
  # keep-sorted start

  mkShellNoCC,
  nil,
  tack,
  tinymist,
  typst,
  websocat,

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
      websocat

      # keep-sorted end
      ;
  };

  strictDeps = true;
  nativeBuildInputs = [
    (typst.withPackages (_: builtins.attrValues { }))
  ];
}
