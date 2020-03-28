{ pkgs }:

let

  ghcWithPackages = pkgs.haskellPackages.ghcWithPackages
    (
      self: with self; [
        xmonad
        xmonad-contrib
        xmonad-extras
        filepath
        directory
        aeson
      ]
    );

in

pkgs.writeScriptBin "xmonad-build" ''
  #!${pkgs.bash}/bin/bash

  ${ghcWithPackages}/bin/ghc \
     --make xmonad.hs -i. -ilib \
     -main-is main -v0 -o "$1"
''
