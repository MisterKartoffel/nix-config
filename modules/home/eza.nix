{ config, lib, ... }:
let
  inherit (config.programs) eza git;
in
{
  programs.eza = lib.mkIf eza.enable {
    icons = "always";
    colors = "always";
    git = git.enable;
    extraOptions = [ "--group-directories-first" ];
  };
}
