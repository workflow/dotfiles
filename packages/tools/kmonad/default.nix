{ pkgs }:

let

  version = "0.3.0";
  kmonad = builtins.fetchurl {
    url = "https://github.com/david-janssen/kmonad/releases/download/${version}/kmonad-${version}-linux";
    sha256 = "02zwp841g5slvqvwha5q1ynww34ayfk1cfb1y32f1zzw7n1b0ia5";
  };

in

  pkgs.stdenvNoCC.mkDerivation {
    name = "kmonad-${version}";
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cp ${kmonad} $out/bin/kmonad
      chmod +x $out/bin/kmonad
    '';
  }
