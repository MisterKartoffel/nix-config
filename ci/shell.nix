{
  mkShellNoCC,
  tack,
}:
mkShellNoCC {
  packages = builtins.attrValues { inherit tack; };
  env.TACK_NIX_CONF_TOKENS = "1";
}
