{
  description = "Kartoffel tries NixOS 2 - Declarative Boogaloo";

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      hostList = builtins.attrNames (builtins.readDir ./hosts);
      overlays = import ./overlays;

      makeEnv =
        system:
        let
          pkgs = import nixpkgs {
            inherit system overlays;
          };
          lib = pkgs.lib.extend (
            _: _: {
              custom = import ./lib { inherit (pkgs) lib; };
            }
          );
        in
        {
          inherit pkgs lib;
        };

      makeHost =
        hostname:
        let
          host = import ./hosts/${hostname};
          env = makeEnv host.modules.system.architecture;
        in
        nixpkgs.lib.nixosSystem {
          inherit (env) pkgs lib;
          system = host.modules.system.architecture;
          modules = [
            ./modules/flake
            home-manager.nixosModules.home-manager
            ./hosts/${hostname}
          ]
          ++ host.modules.system.submodules;
          specialArgs = { inherit inputs; };
        };
    in
    {
      nixosConfigurations = nixpkgs.lib.genAttrs hostList makeHost;
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-secrets = {
      url = "git+ssh://git@github.com/misterkartoffel/nix-secrets.git?ref=main&shallow=1";
      inputs = { };
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
