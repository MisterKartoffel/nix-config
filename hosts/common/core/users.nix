{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.modules) system secrets;
  inherit (lib.custom) relativeToRoot;
  makeAttrs = f: lib.listToAttrs (map f system.users);
in
{
  users.mutableUsers = false;
  users.users = makeAttrs (user: {
    inherit (user) name;
    value = {
      isNormalUser = true;

      inherit (user) extraGroups;
      shell = pkgs.${user.shell};
      description = secrets.name;
      hashedPasswordFile = secrets.${user.name}.password.path;

      openssh.authorizedKeys.keyFiles = lib.mapAttrsToList (
        key: _: relativeToRoot "home/${user.name}/keys/${key}"
      ) (builtins.readDir (relativeToRoot "home/${user.name}/keys"));
    };
  });

  home-manager.users = makeAttrs (user: {
    inherit (user) name;
    value = {
      imports = map relativeToRoot [
        "modules/modules.nix"
        "hosts/${system.hostname}"
        "home/${user.name}"
      ];
      home = {
        username = user.name;
        homeDirectory = "/home/${user.name}";
        inherit (system) stateVersion;
      };
    };
  });
  home-manager.extraSpecialArgs = { inherit inputs; };
}
