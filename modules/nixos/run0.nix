{ config, ... }:
let
  inherit (config.security) run0;
in
{
  security = {
    run0 = {
      enableSudoAlias = true;
      wheelNeedsPassword = false;
    };

    sudo.enable = !run0.enable;
  };
}
