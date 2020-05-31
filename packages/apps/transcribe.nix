{ pkgs }:

let

  transcribe = pkgs.transcribe.overrideAttrs (
    old: {
      src = pkgs.fetchzip {
        url = "https://www.seventhstring.com/xscribe/xsc64setup.tar.gz";
        sha256 = "01vysym52vbly7rss9c6i6wac4lbnfgz37xa5nz8ikqvwnmn34c3";
      };
      meta = old.meta // { broken = false; };
    }
  );

in

pkgs.stdenv.mkDerivation {
  name = "transcribe-wrapped";
  verion = transcribe.version;
  buildInputs = [ pkgs.makeWrapper ];
  buildCommand = ''
    mkdir -p $out/bin
    makeWrapper ${transcribe}/bin/transcribe $out/bin/transcribe \
      --set LD_LIBRARY_PATH ${pkgs.xorg.libXxf86vm}/lib

    mkdir -p $out/share/applications
    cat << EOF > $out/share/applications/transcribe.desktop
    [Desktop Entry]
    Encoding=UTF-8
    Version=1.0
    Type=Application
    Exec=$out/bin/transcribe
    Name=Transcribe
    Comment=Transcribe
    EOF
  '';
}
