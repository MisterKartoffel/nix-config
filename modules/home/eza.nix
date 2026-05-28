{ config, lib, ... }:
let
  inherit (config.programs) eza;
in
{
  programs.eza = lib.mkIf eza.enable {
    icons = "always";
    colors = "always";
    git = true;
    extraOptions = [ "--group-directories-first" ];
  };
}
