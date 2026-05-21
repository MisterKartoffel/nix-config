{ config, lib, ... }:
let
  cfg = config.programs.eza;
in
{
  programs.eza = lib.mkIf cfg.enable {
    icons = "always";
    colors = "always";
    git = true;
    extraOptions = [ "--group-directories-first" ];
  };
}
