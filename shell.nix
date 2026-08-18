{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShellNoCC {
  packages = builtins.attrValues {
    inherit (pkgs)
      tack

      nil
      lua-language-server
      ;
  };

  env = {
    TACK_NIX_CONF_TOKENS = "1";
  };
}
