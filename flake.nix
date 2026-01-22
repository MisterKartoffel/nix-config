{
  description = "Kartoffel tries NixOS 2 - Declarative Boogaloo";

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    hostList = builtins.attrNames (builtins.readDir ./hosts);
    overlays = import ./overlays;

    pkgsFor = system: import nixpkgs {inherit system overlays;};

    formatterFor = system: (pkgsFor system).nixfmt-tree;

    makeHost = hostname: let
      inherit (import ./hosts/${hostname}/hostspec.nix) hostSpec;
      pkgs = pkgsFor hostSpec.system;

      lib = pkgs.lib.extend (
        _: _: {
          custom = import ./lib {inherit (pkgs) lib;};
        }
      );
    in
      nixpkgs.lib.nixosSystem {
        inherit (hostSpec) system;
        inherit pkgs lib;

        modules = [
          ./modules/flake
          home-manager.nixosModules.home-manager
          ./hosts/${hostname}
        ];

        specialArgs = {inherit inputs;};
      };

    makeDevShell = hostname: let
      inherit (import ./hosts/${hostname}/hostspec.nix) hostSpec;
      pkgs = pkgsFor hostSpec.system;
    in {
      ${hostSpec.system}.${hostname} = pkgs.mkShell {
        buildInputs = with pkgs; [
          just
          nh
        ];
      };
    };

    systems =
      builtins.map (
        hostname: (import ./hosts/${hostname}/hostspec.nix).hostSpec.system
      )
      hostList;

    nixosConfigurations = nixpkgs.lib.genAttrs hostList makeHost;
    devShells = nixpkgs.lib.foldl' nixpkgs.lib.recursiveUpdate {} (map makeDevShell hostList);
    formatter = nixpkgs.lib.genAttrs systems formatterFor;
  in {
    inherit nixosConfigurations devShells formatter;
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
      inputs = {};
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
