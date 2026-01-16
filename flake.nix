{
	description = "Kartoffel tries NixOS 2 - Declarative Boogaloo";

	outputs = { nixpkgs, home-manager, ... }@inputs:
		let
			pkgsFor = system: import nixpkgs { inherit system; };
			hostList = builtins.attrNames (builtins.readDir ./hosts);

			hostAttrs = map (hostname:
				let
					inherit ((import ./hosts/${hostname}/hostspec.nix).hostSpec) system;
					pkgs = pkgsFor system;

					drv = nixpkgs.lib.nixosSystem {
						inherit system pkgs;

						lib = nixpkgs.lib.extend (_: _: {
							custom = import ./lib { inherit (nixpkgs) lib; };
						});

						modules = [
							home-manager.nixosModules.home-manager
							./modules/flake
							./hosts/${hostname}
						];

						specialArgs = { inherit inputs; };
					};
				in {
					name = "${hostname}";
					value = drv;
				}
			) hostList;

			nixosConfigurations = builtins.listToAttrs hostAttrs;
		in {
			inherit nixosConfigurations;
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
