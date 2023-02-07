{
  description = "nixos configuration using flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-vimplugins-coc-flutter.url = "github:workflow/nixpkgs/b8ff1009091486567bc217052b80184ab7077d71";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    secrets = {
      url = "path:/home/farlion/code/nixos-secrets";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-vimplugins-coc-flutter, nixos-hardware, home-manager, secrets, ... }@inputs:
    let
      overlays = {
        nixpkgs-vimplugins-coc-flutter = import nixpkgs-vimplugins-coc-flutter {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        unstable = import nixpkgs-unstable {
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
                # Pin registry to current unstable nixpkgs in use to speed up `nix search`
                nixpkgs.flake = nixpkgs-unstable;
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
              users.farlion = import ./home.nix;
              extraSpecialArgs = {
                isNvidia = true;
                inherit inputs;
                inherit secrets;
              };
            };
          }
        ];
      };

      nixosConfigurations.topbox = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          inherit secrets;
        };
        modules = [
          {
            nix = {
              registry = {
                # Pin registry to current nixpkgs in use to speed up `nix search`
                nixpkgs.flake = nixpkgs;
              };
            };

            nixpkgs.overlays = [ (_: _: overlays) ];
          }

          nixpkgs.nixosModules.notDetected

          ./machines/topbox/hardware-scan.nix
          ./machines/topbox/system.nix

          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.farlion = import ./home.nix;
              extraSpecialArgs = {
                isNvidia = false;
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
                # Pin registry to current nixpkgs in use to speed up `nix search`
                nixpkgs.flake = nixpkgs;
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
              users.farlion = import ./home.nix;
              extraSpecialArgs = {
                isNvidia = true;
                inherit inputs;
                inherit secrets;
              };
            };
          }
        ];
      };

    };
}
