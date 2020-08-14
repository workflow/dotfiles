{ pkgs }:
let
  version = "v3.99.2";
  arch = "amd64";

  url = "https://torguard.net/downloads/torguard-latest-${arch}.deb";
  sha256 = "0x1d04fbj6qjbaq1j8zhaazi16fjlbinjyvwzj65ijy2w6zbzdrb";

in
with pkgs;

stdenv.mkDerivation {
  pname = "torguard";
  inherit version;

  src = fetchurl {
    inherit url sha256;
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];
  buildInputs = [
    dbus
    glib
    glibc
    gcc-unwrapped
    libkrb5
    libxkbcommon
    qt4
    xorg.libX11
    xorg.libSM
  ];

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out/bin
    dpkg -x $src $out
    mv $out/opt/torguard/* $out/
  '';
}
