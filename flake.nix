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
        hostSpec:
        let
          pkgs = import nixpkgs {
            inherit (hostSpec) system;
            inherit overlays;
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
          hostSpec = import ./hosts/${hostname};
          env = makeEnv hostSpec;
        in
        nixpkgs.lib.nixosSystem {
          inherit (hostSpec) system;
          inherit (env) pkgs lib;
          modules = [ ./modules/flake ] ++ hostSpec.modules;
          specialArgs = { inherit inputs hostSpec; };
        };

      makeHome =
        hostname:
        let
          hostSpec = import ./hosts/${hostname};
          env = makeEnv hostSpec;
        in
        nixpkgs.lib.listToAttrs (
          map (user: {
            name = "${user.name}@${hostname}";
            value = home-manager.lib.homeManagerConfiguration {
              inherit (env) pkgs lib;
              modules = [
                ./modules/flake/secrets.nix
                ./home/${user.name}
              ];
              extraSpecialArgs = { inherit inputs hostSpec; };
            };
          }) hostSpec.userList
        );
    in
    {
      nixosConfigurations = nixpkgs.lib.genAttrs hostList makeHost;
      homeConfigurations = nixpkgs.lib.mergeAttrsList (map makeHome hostList);
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
