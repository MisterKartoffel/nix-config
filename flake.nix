{
  description = "Kartoffel tries NixOS 2 - Declarative Boogaloo";

  outputs =
    {
      nixpkgs,
      home-manager,
      disko,
      impermanence,
      ...
    }@inputs:
    let
      hostList = builtins.attrNames (builtins.readDir ./hosts);

      makeHost =
        hostname:
        let
          lib = nixpkgs.lib.extend (prev: _: import ./lib { lib = prev; });
        in
        lib.nixosSystem {
          inherit lib;
          modules = [
            home-manager.nixosModules.home-manager
            disko.nixosModules.disko
            impermanence.nixosModules.impermanence
            ./hosts/${hostname}
          ]
          ++ lib.importTree "modules/nixos";
          specialArgs = { inherit inputs; };
        };

      nixosConfigurations = nixpkgs.lib.genAttrs hostList makeHost;

      systems = nixpkgs.lib.unique (
        map (host: host.pkgs.system) (builtins.attrValues nixosConfigurations)
      );
    in
    {
      inherit nixosConfigurations;

      devShells = nixpkgs.lib.genAttrs systems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = import ./shell.nix { inherit pkgs; };
        }
      );
    };

  inputs = {
    nixpkgs = {
      url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "";
      inputs.home-manager.follows = "";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-secrets = {
      url = "git+ssh://git@github.com/misterkartoffel/nix-secrets.git?ref=main&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
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
