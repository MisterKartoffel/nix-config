{ config, lib, ... }:
let
  inherit (config.programs) zathura;
in
{
  programs.zathura = lib.mkIf zathura.enable { };
}
