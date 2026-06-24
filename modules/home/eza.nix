{ config, ... }:
let
  inherit (config.programs) git;
in
{
  programs.eza = {
    icons = "always";
    colors = "always";
    git = git.enable;
    extraOptions = [ "--group-directories-first" ];
  };
}
