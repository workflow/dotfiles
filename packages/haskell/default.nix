{ pkgs, ... }:

let

  hsLib = import ./lib.nix { pkgs = pkgs; };

  ghc-lib-parser = pkgs.haskellPackages.ghc-lib-parser;
  ghc-lib-parser-ex = hsLib.fetchFromHackage {
    name = "ghc-lib-parser-ex";
    version = "8.8.2";
    sha256 = "0ff1rb53wmbkbdral725brs0wg2bg4x2bb2klfwa2cqix1qi68lv";
    overrides = { ghc-lib-parser = ghc-lib-parser; };
  };

  brittany = pkgs.callPackage ./brittany.nix {};
  fast-tags = pkgs.callPackage ./fast-tags.nix {};
  hlint = pkgs.callPackage ./hlint.nix {
    overrides = {
      ghc-lib-parser = ghc-lib-parser;
      ghc-lib-parser-ex = ghc-lib-parser-ex;
    };
  };
  ghcid = pkgs.callPackage ./ghcid.nix {};
  ormolu = pkgs.callPackage ./ormolu.nix {
    overrides = {
      ghc-lib-parser = pkgs.haskellPackages.ghc-lib-parser_8_8_2_20200205;
    };
  };

  ghc = pkgs.callPackage ./ghc.nix {};

in

[
  pkgs.cabal2nix
  pkgs.cabal-install
  pkgs.stack

  brittany
  fast-tags
  hlint
  ghcid
  ormolu

  ghc.ghc865
  ghc.ghc881
  ghc.ghc865Symlinks
]
