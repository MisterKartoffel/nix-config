{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.custom) makeSystemUser makeHomeUser;
  inherit (config.hostSpec) userList;
in
{
  users = {
    users = lib.listToAttrs (
      map (
        user:
        makeSystemUser {
          inherit
            inputs
            config
            pkgs
            user
            ;
        }
      ) userList
    );
    mutableUsers = false;
  };

  home-manager = {
    users = lib.listToAttrs (map (user: makeHomeUser { inherit config user; }) userList);
    extraSpecialArgs = { inherit inputs pkgs; };
  };
}
