{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.custom) relativeToRoot;
  inherit (config.modules) secrets;
  inherit (config.modules.system) users;
in
{
  services.userborn.enable = true;

  users.mutableUsers = false;
  users.users = lib.mapAttrs (username: user: {
    isNormalUser = true;

    inherit (user) extraGroups;
    shell = pkgs.${user.shell};
    description = secrets.home.${username}.name;
    hashedPasswordFile = secrets.host.${username}.password.path;

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
