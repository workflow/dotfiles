{
  description = "nixos configuration using flakes";

  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    nur.url = "github:nix-community/nur";
    rmob.url = "https://flakehub.com/f/workflow/rmob/*.tar.gz";
    secrets = {
      url = "path:/home/farlion/code/nixos-secrets";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix/release-25.11";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    determinate,
    nixpkgs,
    nixos-unstable,
    home-manager,
    impermanence,
    niri,
    nur,
    secrets,
    sops-nix,
    stylix,
    ...
  } @ inputs: let
    commonModules = [
      {
        nixpkgs.overlays = [
          (_: _: overlays)
        ];
      }
      determinate.nixosModules.default
      nixpkgs.nixosModules.notDetected
      ./configuration.nix
      nur.modules.nixos.default
      impermanence.nixosModules.impermanence
      sops-nix.nixosModules.sops
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
    };

    mkSystem = {
      hostname,
      isImpermanent,
      isLaptop,
      isAmd,
      isNvidia,
      extraModules ? [],
    }: let
      machineArgs = {
        inherit inputs secrets isImpermanent isLaptop;
      };
    in
      nixpkgs.lib.nixosSystem {
        specialArgs = machineArgs;
        modules =
          commonModules
          ++ [
            ./machines/${hostname}/hardware-scan.nix
            ./machines/${hostname}/system.nix
            {
              home-manager =
                commonHomeManagerSettings
                // {
                  extraSpecialArgs =
                    machineArgs
                    // {
                      inherit isAmd isNvidia;
                    };
                };
            }
          ]
          ++ extraModules;
      };
  in {
    nixosConfigurations.flexbox = mkSystem {
      hostname = "flexbox";
      isImpermanent = false;
      isLaptop = true;
      isAmd = false;
      isNvidia = true;
      extraModules = [./system/nvidia];
    };

    nixosConfigurations.numenor = mkSystem {
      hostname = "numenor";
      isImpermanent = true;
      isLaptop = false;
      isAmd = true;
      isNvidia = false;
      extraModules = [./system/amd ./system/btrfs];
    };

    # Home-manager standalone configuration for `home-manager news` CLI
    # Uses actual config with all host-specific features enabled for maximum news coverage
    # Actual home-manager is managed via NixOS module (see nixosConfigurations above)
    homeConfigurations.farlion = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = {
        inherit inputs secrets;
        # Enable all host-specific features to get maximum applicable news
        isImpermanent = true;
        isLaptop = true;
        isAmd = true;
        isNvidia = true;
        # Mock osConfig for standalone mode
        osConfig = {
          networking.hostName = "standalone-news-config";
          specialisation = {};
        };
      };
      modules = [
        {
          nixpkgs.overlays = [(_: _: overlays)];
        }
        # Import impermanence home-manager module directly (the flake output is deprecated)
        "${impermanence}/home-manager.nix"
        nur.modules.homeManager.default
        stylix.homeManagerModules.stylix
        niri.homeModules.niri
        {
          home = {
            username = "farlion";
            homeDirectory = "/home/farlion";
          };
          assertions = nixpkgs.lib.mkForce [];
        }
        (import ./home)
      ];
    };

    # Expose profiling helper as a package and an app
    # Call with `nix run .#nh-eval-profile -- <HOST>`
    packages.x86_64-linux.nh-eval-profile = let
      pkgsFor = nixpkgs.legacyPackages.x86_64-linux;
    in
      pkgsFor.callPackage ./system/scripts/nh-eval-profile.nix {};

    apps.x86_64-linux.nh-eval-profile = {
      type = "app";
      program = "${self.packages.x86_64-linux.nh-eval-profile}/bin/nh-eval-profile";
    };
  };
}
