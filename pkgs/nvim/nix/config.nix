{ pkgs, lib }:
{
  runtimePaths = import ./runtime-paths.nix { inherit lib; };
  plugins = import ./plugins.nix { inherit pkgs; };
  treesitter = import ./treesitter.nix { inherit pkgs lib; };
  extraPackages = import ./extra-packages.nix { inherit pkgs; };
}
