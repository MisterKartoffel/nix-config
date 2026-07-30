{ inputs, ... }: {
  imports = [
    inputs.hjem.nixosModules.default
    inputs.preservation.nixosModules.default
    inputs.disko.nixosModules.default
  ];
}
