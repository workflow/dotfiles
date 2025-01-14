{
  description = "nixos configuration using flakes";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    nur.url = "github:nix-community/nur";
    rmob.url = "https://flakehub.com/f/workflow/rmob/*.tar.gz";
    secrets.url = "path:/home/farlion/code/nixos-secrets";
    stylix.url = "github:danth/stylix/release-24.11";
  };

  outputs = {
    nixpkgs,
    nixos-unstable,
    home-manager,
    nur,
    secrets,
    stylix,
    ...
  } @ inputs: let
    overlays = {
      unstable = import nixos-unstable {
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
        isHidpi = false;
        isPpiScaledOnePointFive = true;
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
        nur.modules.nixos.default
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
              isHidpi = false;
              isPpiScaledOnePointFive = true;
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
        isPpiScaledOnePointFive = false;
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
        nur.modules.nixos.default
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
              isPpiScaledOnePointFive = false;
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
