{ config, lib, ... }:
let
  inherit (config.programs) nh;
in
{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      auto-optimise-store = true;
    };

    gc = lib.mkIf (!nh.clean.enable) {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
