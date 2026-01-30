{ lib, ... }:
{
  makeSystemUser =
    {
      config,
      pkgs,
      user,
    }:
    {
      inherit (user) name;
      value = {
        inherit (user) extraGroups;
        shell = pkgs.${user.shell};
        description = config.modules.secrets.name;
        hashedPasswordFile = config.modules.secrets.${user.name}.password.path;

        openssh.authorizedKeys.keyFiles = lib.mapAttrsToList (key: _: ../home/${user.name}/keys/${key}) (
          builtins.readDir ../home/${user.name}/keys
        );

        isNormalUser = true;
      };
    };

  makeHomeUser =
    { config, user }:
    {
      inherit (user) name;
      value = {
        imports = [
          ../modules/flake/modules.nix
          ../hosts/${config.modules.system.hostname}
          ../home/${user.name}
        ];
        home = {
          username = user.name;
          homeDirectory = "/home/${user.name}";
          inherit (config.modules.system) stateVersion;
        };
      };
    };
}
