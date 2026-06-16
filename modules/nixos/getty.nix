{ config, lib, ... }: {
  services.getty = {
    autologinOnce = true;

    autologinUser =
      let
        inherit (config.modules.system) users;
      in
      lib.findFirst (username: users.${username}.autologin) null (builtins.attrNames users);
  };
}
