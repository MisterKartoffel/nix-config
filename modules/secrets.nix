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

  homeManagerSecrets = lib.mkMerge (
    map (user: nestAttrset (user.sops.secrets or { })) (
      lib.attrValues (config.home-manager.users or { })
    )
  );

  flakeSecrets = inputs.nix-secrets or { };

  allSecrets = [
    nixosSecrets
    homeManagerSecrets
    flakeSecrets
  ];
in
{
  config = {
    modules.secrets = lib.foldl' lib.recursiveUpdate { } allSecrets;

    home-manager.sharedModules = [
      {
        config.modules.secrets = config.modules.secrets;
      }
    ];
  };
}
