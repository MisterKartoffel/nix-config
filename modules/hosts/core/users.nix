{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.custom) makeSystemUser;
  inherit (config.hostSpec) userList;
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
      ) userList
    );
    mutableUsers = false;
  };
}
