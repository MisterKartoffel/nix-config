{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.custom) makeSystemUser makeHomeUser;
  inherit (config.modules.system) users;
in
{
  users = {
    users = lib.listToAttrs (
      map (
        user:
        makeSystemUser {
          inherit
            config
            pkgs
            user
            ;
        }
      ) users
    );
    mutableUsers = false;
  };

  home-manager = {
    users = lib.listToAttrs (
      map (
        user:
        makeHomeUser {
          inherit
            config
            user
            ;
        }
      ) users
    );
    extraSpecialArgs = { inherit inputs; };
  };
}
