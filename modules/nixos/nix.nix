{
  inputs,
  config,
  lib,
  ...
}:
{
  nix = {
    registry = lib.pipe inputs [
      (lib.filterAttrs (_: value: value ? outPath))
      (builtins.mapAttrs (_: value: { flake = value; }))
    ];

    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      auto-optimise-store = true;
      use-xdg-base-directories = true;

      substituters = [ "https://misterkartoffel.cachix.org/" ];
      trusted-public-keys = [ "misterkartoffel.cachix.org-1:hSj2uihi9MyLtzjS56ALG9tIIRlQXZfVnPeIIFGG/E4=" ];
    };

    extraOptions = ''
      !include ${config.sops.templates."nix-tokens.conf".path}
    '';
  };
}
