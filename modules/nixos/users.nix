{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (lib) importTree;
  inherit (config.modules) secrets services system;
  inherit (services) sops;
in
{
  services.userborn.enable = true;

  users.mutableUsers = false;
  users.users = lib.mkMerge [
    (lib.mapAttrs (username: user: {
      isNormalUser = true;

      inherit (user) shell extraGroups;
      description = lib.mkIf sops.enable secrets.home.${username}.name;
      initialHashedPassword = lib.mkIf (
        !sops.enable
      ) "$y$j9T$9lxUmIACkk7jFAU437ubP/$/dbwqUcskqwzxBC.Lg7WJx4uf/8jxLGcxRjM36U0q57";
      hashedPasswordFile = lib.mkIf sops.enable secrets.host.${username}.password.path;

      openssh.authorizedKeys.keys = [
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBJRyJ3RdkVQsdZpnQ0+hPPwzI+lg9XprrK3ntSFPldhBsA4sywtAy4U2P+9DtdeON29opxsUyiDd2yprr2iwWG8= termius@s20fe"
      ];
    }) system.users)

    { root.initialPassword = "!"; }
  ];

  home-manager.users = lib.mapAttrs (username: _: {
    imports = builtins.concatMap importTree [
      "home/${username}.nix"
      "modules/home"
    ];
    home = {
      inherit username;
      homeDirectory = "/home/${username}";
      inherit (config.system) stateVersion;
    };
  }) system.users;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
  };
}
