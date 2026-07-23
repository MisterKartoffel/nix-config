{ inputs, ... }: {
  imports = [
    inputs.hjem.nixosModules.default
    inputs.home-manager.nixosModules.default
    inputs.preservation.nixosModules.default
    inputs.disko.nixosModules.default
  ];
}
