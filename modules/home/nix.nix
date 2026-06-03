{ config, ... }:
{
  nix.assumeXdg = config.xdg.enable;
}
