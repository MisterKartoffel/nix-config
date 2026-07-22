{ inputs, ... }: {
  imports = [
    inputs.hjem.nixosModules.default
    inputs.home-manager.nixosModules.default
    inputs.impermanence.nixosModules.default
    inputs.disko.nixosModules.default
  ];
}
