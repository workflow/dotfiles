{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (inputs) nixpkgs home-manager impermanence niri nur sops-nix stylix determinate;

  # All dendritic modules for NixOS
  nixosModules = builtins.attrValues config.flake.modules.nixos;

  # All dendritic modules for home-manager
  homeManagerModules = builtins.attrValues config.flake.modules.homeManager;

  commonOverlays = {
    unstable = import inputs.nixos-unstable {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
  };

  commonNixosModules = [
    {
      nixpkgs.overlays = [
        (_: _: commonOverlays)
      ];
    }
    determinate.nixosModules.default
    nixpkgs.nixosModules.notDetected
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
    sharedModules =
      homeManagerModules
      ++ [
        "${impermanence}/home-manager.nix"
        nur.modules.homeManager.default
        stylix.homeManagerModules.stylix
        niri.homeModules.niri
      ];
  };

  mkHost = {
    hostname,
    hostModule,
    dendrixConfig,
    extraModules ? [],
  }:
    nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        secrets = inputs.secrets;
      };
      modules =
        commonNixosModules
        ++ nixosModules
        ++ [
          # Host-specific hardware and settings
          hostModule

          # Set dendrix options
          {
            dendrix = dendrixConfig;
          }

          # Home-manager configuration
          {
            home-manager =
              commonHomeManagerSettings
              // {
                users.farlion = {pkgs, ...}: {
                  home.stateVersion = dendrixConfig.homeStateVersion;
                };
              };
          }
        ]
        ++ extraModules;
    };
in {
  flake.nixosConfigurations = {
    flexbox = mkHost {
      hostname = "flexbox";
      hostModule = ./hosts/flexbox;
      dendrixConfig = {
        hostname = "flexbox";
        isLaptop = true;
        isImpermanent = false;
        hasNvidia = true;
        hasAmd = false;
        stateVersion = "22.05";
        homeStateVersion = "22.05";
      };
    };

    numenor = mkHost {
      hostname = "numenor";
      hostModule = ./hosts/numenor;
      dendrixConfig = {
        hostname = "numenor";
        isLaptop = false;
        isImpermanent = true;
        hasNvidia = false;
        hasAmd = true;
        stateVersion = "24.11";
        homeStateVersion = "24.11";
      };
    };
  };
}
