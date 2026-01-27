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
        description = config.secrets.name;
        hashedPasswordFile = config.secrets.${user.name}.password.path;

        openssh.authorizedKeys.keyFiles = lib.mapAttrsToList (key: _: ../home/${user.name}/keys/${key}) (
          builtins.readDir ../home/${user.name}/keys
        );

        isNormalUser = true;
      };
    };

  makeHomeUser =
    {
      config,
      user,
    }:
    {
      inherit (user) name;
      value = {
        imports = [ ../home/${user.name} ];
        home = {
          username = user.name;
          homeDirectory = "/home/${user.name}";
          inherit (config.hostSpec) stateVersion;
        };
      };
    };

  relativeToRoot = lib.path.append ../.;

  importSelf =
    dir:
    let
      entries = builtins.readDir dir;
      contents = lib.filter (name: lib.hasSuffix ".nix" name && name != "default.nix") (
        lib.attrNames entries
      );
    in
    map (name: dir + "/${name}") contents;
}
