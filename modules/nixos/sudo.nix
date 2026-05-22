{ config, ... }:
let
  cfg = config.security.run0;
in
{
  security.sudo.enable = !cfg.enableSudoAlias;
}
