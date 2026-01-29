{
  inputs,
  config,
  lib,
  ...
}:
let
  nestAttrset =
    secrets:
    lib.foldlAttrs (
      acc: path: value:
      lib.recursiveUpdate acc (lib.attrsets.setAttrByPath (lib.splitString "/" path) value)
    ) { } secrets;

  nixosSecrets = nestAttrset (config.sops.secrets or { });
  flakeSecrets = inputs.nix-secrets or { };

  secrets = lib.recursiveUpdate nixosSecrets flakeSecrets;
in
{
  config.modules = { inherit secrets; };
}
