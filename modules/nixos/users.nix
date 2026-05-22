{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) relativeToRoot;
  inherit (config.modules) secrets services system;
  inherit (system) users;
  inherit (services) sops;
in
{
  services.userborn.enable = true;

  users.mutableUsers = false;
  users.users = lib.mapAttrs (username: user: {
    isNormalUser = true;

    inherit (user) extraGroups;
    shell = pkgs.${user.shell};
    description = lib.mkIf sops.enable secrets.home.${username}.name;
    initialHashedPassword = lib.mkIf (
      !sops.enable
    ) "$y$j9T$9lxUmIACkk7jFAU437ubP/$/dbwqUcskqwzxBC.Lg7WJx4uf/8jxLGcxRjM36U0q57";
    hashedPasswordFile = lib.mkIf sops.enable secrets.host.${username}.password.path;

    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBJRyJ3RdkVQsdZpnQ0+hPPwzI+lg9XprrK3ntSFPldhBsA4sywtAy4U2P+9DtdeON29opxsUyiDd2yprr2iwWG8= termius@s20fe"
    ];
  }) users;

  home-manager.users = lib.mapAttrs (username: _: {
    imports = map relativeToRoot [ "home/${username}.nix" ];
    home = {
      inherit username;
      homeDirectory = "/home/${username}";
      inherit (config.system) stateVersion;
    };
  }) users;
  home-manager.extraSpecialArgs = { inherit inputs; };
}
