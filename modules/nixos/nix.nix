{
  inputs,
  config,
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

    gc = {
      automatic = !nh.clean.enable;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
