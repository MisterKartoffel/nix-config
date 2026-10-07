{
  inputs,
  self,
  config,
  lib,
  ...
}:
let
  inherit (config.modules.services) sops;
  inherit (config.modules) users;
  inherit (config.sops) secrets;
in
{
  imports = [ inputs.hjem.nixosModules.default ];

  services.userborn.enable = true;

  users.mutableUsers = false;
  users.users =
    (builtins.mapAttrs (username: user: {
      isNormalUser = true;
      inherit (user) shell description extraGroups;

      initialPassword = lib.mkIf (!sops.enable) "nixos";
      hashedPasswordFile = lib.mkIf sops.enable secrets."${username}/password".path;

      openssh = { inherit (user) authorizedKeys; };
    }) users)
    // {
      root.initialPassword = "!";
    };

  hjem.users = builtins.mapAttrs (username: _: {
    imports = self.hjemModules.default ++ [
      (self.outPath + "/users/${username}.nix")
    ];
  }) users;

  hjem = {
    specialArgs = { inherit self inputs; };
    clobberByDefault = true;
  };
}
