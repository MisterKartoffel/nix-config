# The purpose of this module
# is to merge the following attrsets:
#
# - config.sops.secrets
# (NixOS module secrets)
#
# - config.home-manager.users.<user>.sops.secrets
# (Home-Manager module secrets)
#
# - inputs.nix-secrets
# (Unencrypted flake output from nix-secrets)
#
# Into a single attrset under config.secrets.
{
  inputs,
  config,
  lib,
  ...
}:
let
  toPairs =
    attrs:
    lib.mapAttrsToList (name: value: {
      inherit name value;
    }) attrs;

  prefixPairs =
    prefix: pairs:
    map (pair: {
      name = "${prefix}/${pair.name}";
      inherit (pair) value;
    }) pairs;

  foldToNested =
    pairs:
    lib.foldl' (
      acc: item:
      lib.attrsets.recursiveUpdate acc (
        lib.attrsets.setAttrByPath (lib.splitString "/" item.name) item.value
      )
    ) { } pairs;

  systemPairs = toPairs config.sops.secrets;

  userPairs = lib.concatMap (
    user: prefixPairs user.name (toPairs config.home-manager.users.${user.name}.sops.secrets)
  ) config.hostSpec.userList;

  flakePairs = toPairs inputs.nix-secrets;

  allPairs = lib.concatLists [
    systemPairs
    userPairs
    flakePairs
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
    secrets = foldToNested allPairs;

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
