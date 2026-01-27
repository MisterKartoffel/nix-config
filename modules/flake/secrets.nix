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

  homeManagerSecrets = lib.foldlAttrs (
    acc: _: user:
    lib.recursiveUpdate acc (nestAttrset (user.sops.secrets or { }))
  ) { } (config.home-manager.users or { });

  flakeSecrets = inputs.nix-secrets or { };

  allSecrets = [
    nixosSecrets
    homeManagerSecrets
    flakeSecrets
  ];
in
{
  options.secrets = lib.mkOption {
    type = lib.types.attrs;
    description = ''
      Nested secrets derived from sops.secrets.
      Accessible in NixOS modules as config.secrets.<path>.
    '';
    default = { };
  };

  config = {
    secrets = lib.foldl' lib.recursiveUpdate { } allSecrets;

    home-manager.sharedModules = [
      {
        options.secrets = lib.mkOption {
          type = lib.types.attrs;
          description = ''
            Nested secrets derived from sops.secrets.
            Accessible in Home-Manager modules as config.secrets.<path>.
          '';
          default = { };
        };
        config.secrets = config.secrets;
      }
    ];
  };
}
