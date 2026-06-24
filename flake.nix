{
  outputs =
    _:
    let
      inputs = import ./.tack;
      lib = inputs.nixpkgs.lib.extend (_: prev: { custom = import ./lib { lib = prev; }; });
      forAllSystems =
        f: lib.genAttrs lib.systems.flakeExposed (system: f inputs.nixpkgs.legacyPackages.${system});
    in
    {
      nixosConfigurations = builtins.mapAttrs (
        hostname: _:
        lib.nixosSystem {
          inherit lib;
          modules = lib.custom.importTree "modules/nixos" ++ [
            inputs.home-manager.nixosModules.default
            inputs.impermanence.nixosModules.default
            inputs.disko.nixosModules.default
            ./hosts/${hostname}
          ];
          specialArgs = { inherit inputs; };
        }
      ) (builtins.readDir ./hosts);

      devShells = forAllSystems (pkgs: {
        default = pkgs.callPackage ./shell.nix { inherit inputs; };
      });
    };
}
