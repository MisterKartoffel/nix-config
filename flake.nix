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
          system:
          apply (
            import inputs.nixpkgs {
              inherit system;
              overlays = [ self.overlays.default ];
            }
          )
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

      apps = forAllSystems (
        pkgs:
        lib.mapAttrs
          (_: app: {
            type = "app";
            program = lib.getExe app;
          })
          (
            lib.packagesFromDirectoryRecursive {
              inherit (pkgs) callPackage;
              directory = ./apps;
            }
          )
      );

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
        pkgs: pkgs.treefmt.withConfig (import ./ci/treefmt.nix { inherit pkgs lib; })
      );

      templates = lib.genAttrs (builtins.attrNames (builtins.readDir ./templates)) (language: {
        path = ./templates/${language};
        description = "Template for ${language}";
      });

      overlays.default = lib.composeManyExtensions (
        lib.mapAttrsToList (name: _: import ./overlays/${name}) (builtins.readDir ./overlays)
      );
    };
}
