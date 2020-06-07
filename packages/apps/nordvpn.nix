{ pkgs }:

let

  version = "3.7.3";
  arch = "amd64";

  url = "https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn_${version}_${arch}.deb";
  sha256 = "05hga13ssq2nqgpjcr4xn32asmz7k28f1nmjqhzk3r5vpmk2n7lv";

in

pkgs.stdenv.mkDerivation {
  name = "nordvpn-${version}";
  version = version;

  src = pkgs.fetchurl {
    url = url;
    sha256 = sha256;
  };

  nativeBuildInputs = [
    pkgs.dpkg
    pkgs.autoPatchelfHook
  ];
  buildInputs = [
    pkgs.glibc
    pkgs.gcc-unwrapped
  ];

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out
    dpkg -x $src $out
  '';
}

