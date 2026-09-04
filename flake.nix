#
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
        lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (
          system: apply inputs.nixpkgs.legacyPackages.${system}
        );
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

      packages = forAllSystems (
        pkgs:
        lib.packagesFromDirectoryRecursive {
          callPackage = pkgs.newScope {
            inherit (inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}) zen-browser-unwrapped;
          };
          directory = ./pkgs;
        }
      );

      formatter = forAllSystems (
        pkgs: pkgs.treefmt.withConfig (import ./treefmt.nix { inherit pkgs lib; })
      );
    };
}
