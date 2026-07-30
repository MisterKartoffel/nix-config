{
  outputs =
    { self, ... }@args:
    let
      inputs = (import ./.tack) { overrides = args.tackOverrides or { }; };
      lib = inputs.nixpkgs.lib.extend (_: prev: { custom = import ./lib { lib = prev; }; });
      forAllSystems =
        apply:
        lib.genAttrs lib.systems.flakeExposed (system: apply inputs.nixpkgs.legacyPackages.${system});
    in
    {
      nixosConfigurations = builtins.mapAttrs (
        hostname: _:
        lib.nixosSystem {
          inherit lib;
          modules = lib.custom.importTree [
            "hosts/${hostname}"
            "modules/nixos"
          ];
          specialArgs = { inherit self inputs; };
        }
      ) (builtins.readDir ./hosts);

      devShells = forAllSystems (pkgs: {
        default = pkgs.callPackage ./shell.nix { };
      });

      packages = forAllSystems (pkgs: {
        nvim = pkgs.callPackage ./pkgs/nvim { };
        zen-browser = pkgs.callPackage ./pkgs/zen-browser { inherit inputs; };
      });

      formatter = forAllSystems (pkgs: pkgs.treefmt.withConfig (import ./treefmt.nix { inherit pkgs; }));
    };
}
