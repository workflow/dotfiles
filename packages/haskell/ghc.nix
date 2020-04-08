{ pkgs, ... }:

let

  ghcQualified = orig:
    let
      name = "wrapped-${orig.name}";
    in
      pkgs.runCommand name {
        name = name;
        version = orig.version;
      } ''
        mkdir -p $out/bin
        ver=${orig.version}
        cp ${orig}/bin/*-$ver $out/bin/
        for f in hp2ps hsc2hs hpc; do
          cp ${orig}/bin/$f $out/bin/$f-$ver
        done
      '';

  recoverSymlinks = wrapped:
    let
      name = "recover-${wrapped.name}";
    in
      pkgs.runCommand name {
        name = name;
        version = wrapped.version;
      } ''
        mkdir -p $out/bin
        ver=${wrapped.version}
        for f in ghc ghci hp2ps hsc2hs hpc; do
          ln -s ${wrapped}/bin/$f-$ver $out/bin/$f
        done
      '';

in
rec {
  ghc865 = ghcQualified pkgs.haskell.compiler.ghc865;
  ghc881 = ghcQualified pkgs.haskell.compiler.ghc881;
  ghc865Symlinks = recoverSymlinks ghc865;
}
