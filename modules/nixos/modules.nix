{ inputs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.default
    inputs.impermanence.nixosModules.default
    inputs.disko.nixosModules.default
  ];
}
