{
  description = "nixos configuration using flakes";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
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
    impermanence,
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
    nixosConfigurations.flexbox = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
        inherit secrets;
        waylandScaleFactor = 2.0;
        isImpermanent = false;
      };
      modules = [
        {
          nixpkgs.overlays = [(_: _: overlays)];
        }
        nixpkgs.nixosModules.notDetected
        ./machines/flexbox/hardware-scan.nix
        ./machines/flexbox/system.nix
        ./system/nvidia
        ./configuration.nix
        nur.modules.nixos.default
        impermanence.nixosModules.impermanence
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "home-manager-backup";
            users.farlion = import ./home;
            extraSpecialArgs = {
              isAmd = false;
              isImpermanent = false;
              isLaptop = true;
              isNvidia = true;
              waylandScaleFactor = 2.0;
              inherit inputs;
              inherit secrets;
            };
          };
        }
        stylix.nixosModules.stylix
      ];
    };

    nixosConfigurations.numenor = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
        inherit secrets;
        isImpermanent = false;
        waylandScaleFactor = 1.5;
      };
      modules = [
        {
          nixpkgs.overlays = [(_: _: overlays)];
        }
        nixpkgs.nixosModules.notDetected
        ./machines/numenor/hardware-scan.nix
        ./machines/numenor/system.nix
        ./system/amd
        ./system/btrfs
        ./configuration.nix
        nur.modules.nixos.default
        impermanence.nixosModules.impermanence
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "home-manager-backup";
            users.farlion = import ./home;
            extraSpecialArgs = {
              isAmd = true;
              isImpermanent = false;
              isLaptop = false;
              isNvidia = false;
              waylandScaleFactor = 1.5;
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
