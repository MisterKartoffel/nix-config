{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (config.programs) nh;
in
{
  nix = {
    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

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
