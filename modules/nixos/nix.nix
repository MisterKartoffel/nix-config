{ config, ... }:
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

    gc = {
      automatic = !nh.clean.enable;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
