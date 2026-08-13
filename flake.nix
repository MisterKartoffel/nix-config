{
  outputs =
    { self, ... }@args:
    let
      inputs = (import ./.tack) { overrides = args.tackOverrides or { }; };
      inherit (inputs.nixpkgs) lib;

      importTree =
        path:
        lib.fileset.toList (
          lib.fileset.fileFilter (file: file.hasExt "nix" && !(lib.hasPrefix "_" file.name)) ./${path}
        );

      forAllSystems =
        apply:
        lib.genAttrs lib.systems.flakeExposed (system: apply inputs.nixpkgs.legacyPackages.${system});
    in
    {
      nixosConfigurations = builtins.mapAttrs (
        hostname: _:
        lib.nixosSystem {
          modules = importTree "hosts/${hostname}" ++ self.nixosModules.default;
          specialArgs = { inherit self inputs; };
        }
      ) (builtins.readDir ./hosts);

      nixosModules.default = importTree "modules/nixos";
      hjemModules.default = importTree "modules/hjem";

      devShells = forAllSystems (pkgs: {
        default = pkgs.callPackage ./shell.nix { };
      });

      packages = forAllSystems (pkgs: {
        nvim = pkgs.callPackage ./pkgs/nvim (import ./pkgs/nvim/nix/config.nix { inherit pkgs lib; });
        fish = pkgs.callPackage ./pkgs/fish { };
        zen-browser = pkgs.callPackage ./pkgs/zen-browser { inherit inputs; };
      });

      formatter = forAllSystems (
        pkgs: pkgs.treefmt.withConfig (import ./treefmt.nix { inherit pkgs lib; })
      );
    };
}
