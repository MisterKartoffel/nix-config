{
  mkShell,
  tack,
  nil,
  nixfmt,
  lua-language-server,
}:
mkShell {
  packages = [
    tack
    nil
    nixfmt

    lua-language-server
  ];
}
