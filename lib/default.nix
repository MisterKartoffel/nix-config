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

        openssh.authorizedKeys.keyFiles = map (name: ../home/${user.name}/keys/${name}) (
          builtins.attrNames (builtins.readDir ../home/${user.name}/keys)
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
        imports = [ user.homeModule ];
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
