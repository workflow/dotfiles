{
  description = "nixos configuration using flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/21de2b973f9fee595a7a1ac4693efff791245c34";
    nixpkgs-vimplugins-coc-flutter.url = "github:workflow/nixpkgs/b8ff1009091486567bc217052b80184ab7077d71";
    nixos-hardware.url = "github:nixos/nixos-hardware/39a7bfc496d2ddfce73fe9542af1f2029ba4fe39";
    home-manager = {
      url = "github:nix-community/home-manager/4c5106ed0f3168ff2df21b646aef67e86cbfc11c";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-vimplugins-coc-flutter, nixos-hardware, home-manager, ... }@inputs:
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
        specialArgs = { inherit inputs; };
        modules = [
          { nixpkgs.overlays = [ (_: _: overlays) ]; }
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
                inherit inputs;
                hostName = "boar";
                isNvidia = true;
              };
            };
          }
        ];
      };
    };
}
