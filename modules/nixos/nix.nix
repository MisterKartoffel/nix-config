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
    };

    extraOptions = ''
      !include ${config.sops.templates."nix-tokens.conf".path}
    '';
  };
}
