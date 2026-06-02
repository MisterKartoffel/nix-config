{ config, lib, ... }:
let
  inherit (config.programs) direnv;
in
{
  programs.direnv = lib.mkIf direnv.enable {
    nix-direnv.enable = true;
  };
}
