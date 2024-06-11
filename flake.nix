{
  description = "nixos configuration using flakes";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nil.url = "github:oxalica/nil";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-2311.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    rmob = {
      url = "https://flakehub.com/f/workflow/rmob/*.tar.gz";
    };
    secrets = {
      url = "path:/home/farlion/code/nixos-secrets";
    };
  };

  outputs = { self, nil, nix-index-database, nixpkgs, nixpkgs-2311, nixpkgs-unstable, nixos-hardware, home-manager, secrets, ... }@inputs:
    let
      overlays = {
        unstable = import nixpkgs-unstable {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        twentythreeeleven = import nixpkgs-2311 {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
      };
    in
    {
      nixosConfigurations.boar = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          inherit secrets;
        };
        modules = [
          {
            nix = {
              registry = {
                nixpkgs-local.flake = nixpkgs;
                nixpkgs-unstable-local.flake = nixpkgs-unstable;
              };
            };

            nixpkgs.overlays = [ (_: _: overlays) ];
          }
          nixpkgs.nixosModules.notDetected

          ./machines/boar/hardware-scan.nix
          ./machines/boar/system.nix

          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "home-manager-backup";
              users.farlion = import ./home.nix;
              extraSpecialArgs = {
                isNvidia = true;
                isHidpi = false;
                inherit inputs;
                inherit secrets;
              };
            };
          }
        ];
      };

      nixosConfigurations.flexbox = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          inherit secrets;
        };
        modules = [
          {
            nix = {
              registry = {
                nixpkgs-local.flake = nixpkgs;
                nixpkgs-unstable-local.flake = nixpkgs-unstable;
              };
            };

            nixpkgs.overlays = [ (_: _: overlays) ];
          }

          nixpkgs.nixosModules.notDetected

          ./machines/flexbox/hardware-scan.nix
          ./machines/flexbox/system.nix

          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "home-manager-backup";
              users.farlion = import ./home.nix;
              extraSpecialArgs = {
                isNvidia = true;
                isHidpi = true;
                inherit inputs;
                inherit secrets;
              };
            };
          }
        ];
      };

    };
}
