{
  description = "nixos configuration using flakes";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-2311.url = "github:nixos/nixpkgs/nixos-23.11";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    rmob.url = "https://flakehub.com/f/workflow/rmob/*.tar.gz";
    secrets.url = "path:/home/farlion/code/nixos-secrets";
    stylix.url = "github:danth/stylix/993fcabd83d1e0ee5ea038b87041593cc73c1ebe";
  };

  outputs = {
    nixpkgs,
    nixpkgs-2311,
    nixos-unstable,
    home-manager,
    secrets,
    stylix,
    ...
  } @ inputs: let
    overlays = {
      unstable = import nixos-unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      twentythreeeleven = import nixpkgs-2311 {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    };
  in {
    nixosConfigurations.boar = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
        inherit secrets;
        isHidpi = true;
      };
      modules = [
        {
          nix = {
            registry = {
              nixpkgs-local.flake = nixpkgs;
              nixos-unstable-local.flake = nixos-unstable;
            };
          };
          nixpkgs.overlays = [(_: _: overlays)];
        }
        nixpkgs.nixosModules.notDetected
        ./machines/boar/hardware-scan.nix
        ./machines/boar/system.nix
        ./system/amd
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "home-manager-backup";
            users.farlion = import ./home.nix;
            extraSpecialArgs = {
              isAmd = true;
              isNvidia = false;
              isHidpi = true;
              inherit inputs;
              inherit secrets;
            };
          };
        }
        stylix.nixosModules.stylix
      ];
    };

    nixosConfigurations.flexbox = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
        inherit secrets;
        isHidpi = true;
      };
      modules = [
        {
          nix = {
            registry = {
              nixpkgs-local.flake = nixpkgs;
              nixos-unstable-local.flake = nixos-unstable;
            };
          };
          nixpkgs.overlays = [(_: _: overlays)];
        }
        nixpkgs.nixosModules.notDetected
        ./machines/flexbox/hardware-scan.nix
        ./machines/flexbox/system.nix
        ./system/nvidia
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "home-manager-backup";
            users.farlion = import ./home.nix;
            extraSpecialArgs = {
              isAmd = false;
              isNvidia = true;
              isHidpi = true;
              inherit inputs;
              inherit secrets;
            };
          };
        }
        stylix.nixosModules.stylix
      ];
    };
  };
}
