{
  outputs =
    args:
    let
      inputs = (import ./.tack) { overrides = args.tackOverrides or { }; };
      inherit (inputs.nixpkgs) lib;

      forAllSystems =
        apply:
        lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (
          system: apply inputs.nixpkgs.legacyPackages.${system}
        );
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.callPackage ./shell.nix { };
      });

      formatter = forAllSystems (
        pkgs: pkgs.treefmt.withConfig (import ./treefmt.nix { inherit pkgs lib; })
      );
    };
}
