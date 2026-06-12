{
  description = "Kartoffel tries NixOS 2 - Declarative Boogaloo";

  outputs =
    _:
    let
      inputs = import ./.tack;
      lib = inputs.nixpkgs.lib.extend (_: prev: { custom = import ./lib { lib = prev; }; });
      forAllSystems = lib.genAttrs lib.systems.flakeExposed;

      modules =
        hostname:
        lib.custom.importTree "modules/nixos"
        ++ [
          inputs.home-manager.nixosModules.default
          inputs.impermanence.nixosModules.default
          inputs.disko.nixosModules.default
          ./hosts/${hostname}
        ];
    in
    {
      nixosConfigurations = builtins.mapAttrs (
        hostname: _:
        lib.nixosSystem {
          inherit lib;
          modules = modules hostname;
          specialArgs = { inherit inputs; };
        }
      ) (builtins.readDir ./hosts);

      devShells = forAllSystems (
        system:
        let
          pkgs = import inputs.nixpkgs { inherit system; };
        in
        {
          default = pkgs.callPackage ./shell.nix { inherit inputs system; };
        }
      );
    };
}
