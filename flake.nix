{
  outputs =
    args:
    let
      inputs = (import ./.tack) { overrides = args.tackOverrides or { }; };
      lib = inputs.nixpkgs.lib.extend (_: prev: { custom = import ./lib { lib = prev; }; });
      forAllSystems =
        f: lib.genAttrs lib.systems.flakeExposed (system: f inputs.nixpkgs.legacyPackages.${system});
    in
    {
      nixosConfigurations = builtins.mapAttrs (
        hostname: _:
        lib.nixosSystem {
          inherit lib;
            inputs.home-manager.nixosModules.default
            inputs.impermanence.nixosModules.default
            inputs.disko.nixosModules.default
            ./hosts/${hostname}
          modules = lib.custom.importTree [
          ];
          specialArgs = { inherit inputs; };
        }
      ) (builtins.readDir ./hosts);

      devShells = forAllSystems (pkgs: {
        default = pkgs.callPackage ./shell.nix { };
      });

      packages = forAllSystems (pkgs: {
        nvim = pkgs.callPackage ./pkgs/nvim.nix { };
      });
    };
}
