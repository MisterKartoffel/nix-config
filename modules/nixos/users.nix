{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.custom) relativeToRoot;
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

    openssh.authorizedKeys.keyFiles = lib.mapAttrsToList (
      key: _: relativeToRoot "home/${username}/keys/${key}"
    ) (builtins.readDir (relativeToRoot "home/${username}/keys"));
  }) users;

  home-manager.users = lib.mapAttrs (username: _: {
    imports = map relativeToRoot [ "home/${username}" ];
    home = {
      inherit username;
      homeDirectory = "/home/${username}";
      inherit (config.system) stateVersion;
    };
  }) users;
  home-manager.extraSpecialArgs = { inherit inputs; };
}
