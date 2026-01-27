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
  options.secrets = lib.mkOption {
    type = lib.types.attrs;
    description = ''
      Nested secrets derived from sops.secrets.
      Accessible in modules as config.secrets.<path>.
    '';
    default = { };
  };

  config = { inherit secrets; };
}
