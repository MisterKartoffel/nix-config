{ config, lib, ... }:
let
  inherit (config.security) run0;
in
{
  security = lib.mkIf run0.enable {
    run0 = {
      enableSudoAlias = true;
      wheelNeedsPassword = false;
    };

    sudo.enable = false;
  };
}
