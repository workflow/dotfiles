{ pkgs }:

let

  vlc = pkgs.vlc;

in

pkgs.stdenv.mkDerivation {
  name = "vlc-wrapped";
  verion = vlc.version;
  buildInputs = [ pkgs.makeWrapper ];
  buildCommand = ''
    mkdir -p $out/bin
    makeWrapper ${vlc}/bin/vlc $out/bin/vlc \
      --set QT_AUTO_SCREEN_SCALE_FACTOR 0

    mkdir -p $out/share
    cp -R ${vlc}/share/icons $out/share/icons

    mkdir -p $out/share/applications
    cat << EOF > $out/share/applications/vlc.desktop
    [Desktop Entry]
    Encoding=UTF-8
    Version=${vlc.version}
    Type=Application
    Exec=$out/bin/vlc
    Name=VLC
    Comment=VLC Media Player
    Icon=vlc
    EOF
  '';
}
