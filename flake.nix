{
	description = "Kartoffel tries NixOS 2 - Declarative Boogaloo";

	outputs = { nixpkgs, home-manager, ... }@inputs:
		let
			pkgsFor = systemArch: import nixpkgs { system = systemArch; };
			hostList = let
				hosts = builtins.readDir ./hosts;
			in
				builtins.filter (name: name != "common" && hosts.${name} == "directory")
					(builtins.attrNames hosts);

			hostAttrs = map (hostname:
				let
					metadata = import ./hosts/${hostname}/metadata.nix { inherit pkgsFor; };
					system = metadata.hostSpec.systemArch;
					pkgs = pkgsFor system;

					customLib = nixpkgs.lib.extend (_: _: {
						custom = import ./lib {
							inherit (nixpkgs) lib;
							inherit inputs;
						};
					});

					metadataModule = { 
						config.hostSpec = metadata.hostSpec;
					};

					modules = [
						./modules/host-spec.nix
						metadataModule
						home-manager.nixosModules.home-manager
						./hosts/${hostname}
					];

					drv = nixpkgs.lib.nixosSystem {
						inherit system modules pkgs;
						lib = customLib;
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

		firefox-addons = {
			url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nvf = {
			url = "github:notashelf/nvf";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};
}
