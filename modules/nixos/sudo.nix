{ config, ... }:
let
  inherit (config.security) run0;
in
{
  security.sudo.enable = !run0.enableSudoAlias;
}
