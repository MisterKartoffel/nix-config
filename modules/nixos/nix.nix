{
  inputs,
  config,
  lib,
  ...
}:
{
  nix =
    let
      flakes = lib.filterAttrs (_: input: input ? outPath) inputs;
    in
    {
      channel.enable = false;
      registry = builtins.mapAttrs (_: flake: { inherit flake; }) flakes;
      nixPath = lib.mapAttrsToList (name: _: "${name}=flake:${name}") flakes;

      settings = {
        flake-registry = "";
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        auto-optimise-store = true;
        use-xdg-base-directories = true;

        extra-substituters = [ "https://misterkartoffel.cachix.org/" ];
        extra-trusted-public-keys = [
          "misterkartoffel.cachix.org-1:hSj2uihi9MyLtzjS56ALG9tIIRlQXZfVnPeIIFGG/E4="
        ];
      };

      extraOptions = ''
        !include ${config.sops.templates."nix-tokens.conf".path}
      '';
    };
}
