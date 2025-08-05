{
  description = "nixos configuration using flakes";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    niri = {
      url = "github:sodiboo/niri-flake";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-waybar.url = "github:nixos/nixpkgs/3078b9a9e75f1790e6d6ef9955fdc6a2d1740cc6";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    nur.url = "github:nix-community/nur";
    rmob.url = "https://flakehub.com/f/workflow/rmob/*.tar.gz";
    secrets.url = "path:/home/farlion/code/nixos-secrets";
    stylix.url = "github:danth/stylix/release-25.05";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixos-unstable,
    nixpkgs-waybar,
    home-manager,
    impermanence,
    niri,
    nur,
    secrets,
    stylix,
    ...
  } @ inputs: let
    commonModules = [
      {
        nixpkgs.overlays = [(_: _: overlays)];
      }
      nixpkgs.nixosModules.notDetected
      ./configuration.nix
      nur.modules.nixos.default
      impermanence.nixosModules.impermanence
      stylix.nixosModules.stylix
      home-manager.nixosModules.home-manager
      niri.nixosModules.niri
    ];
    commonHomeManagerSettings = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "home-manager-backup";
      users.farlion = import ./home;
    };
    overlays = {
      unstable = import nixos-unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      nixpkgs-waybar = import nixpkgs-waybar {
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
      modules =
        commonModules
        ++ [
          ./machines/flexbox/hardware-scan.nix
          ./machines/flexbox/system.nix
          ./system/nvidia
          {
            home-manager =
              commonHomeManagerSettings
              // {
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
        ];
    };

    nixosConfigurations.numenor = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
        inherit secrets;
        isImpermanent = true;
        waylandScaleFactor = 1.5;
      };
      modules =
        commonModules
        ++ [
          ./machines/numenor/hardware-scan.nix
          ./machines/numenor/system.nix
          ./system/amd
          ./system/btrfs
          {
            home-manager =
              commonHomeManagerSettings
              // {
                extraSpecialArgs = {
                  isAmd = true;
                  isImpermanent = true;
                  isLaptop = false;
                  isNvidia = false;
                  waylandScaleFactor = 1.5;
                  inherit inputs;
                  inherit secrets;
                };
              };
          }
        ];
    };
  };
}
