{
  mkShell,
  tack,
  nil,
  lua-language-server,
}:
mkShell {
  packages = [
    tack

    nil
    lua-language-server
  ];
}
