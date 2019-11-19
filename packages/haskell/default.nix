{ pkgs, ... }:

let

  sources = import ../../nix/sources.nix;
  nixos-beta = import sources.nixos-beta { };

  overrides = {
    ghc-lib-parser = nixos-beta.haskellPackages.ghc-lib-parser_8_8_1;
  };

  fast-tags = pkgs.callPackage ./fast-tags.nix { };
  hlint = pkgs.callPackage ./hlint.nix { overrides = overrides; };
  ghcid = pkgs.callPackage ./ghcid.nix { };
  ormolu = pkgs.callPackage ./ormolu.nix { overrides = overrides; };

  ghc = pkgs.callPackage ./ghc.nix { };

in {
  environment.systemPackages = [
    pkgs.cabal2nix
    pkgs.cabal-install
    pkgs.stack

    fast-tags
    hlint
    ghcid
    ormolu

    ghc.ghc865
    ghc.ghc881
    ghc.ghc865Symlinks
  ];
}
