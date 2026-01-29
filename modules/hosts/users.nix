{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.custom) makeSystemUser;
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
}
