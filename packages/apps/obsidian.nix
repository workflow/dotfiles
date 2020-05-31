{ pkgs }:

let

  version = "0.6.4";

  app = "Obsidian-${version}.AppImage";
  url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${version}/${app}";
  sha256 = "14yawv9k1j4lly9c5hricvzn9inzx23q38vsymgwwy6qhkpkrjcb";

  icon = pkgs.fetchurl {
    url = "https://avatars3.githubusercontent.com/u/65011256";
    sha256 = "114nh45qkvawvnz9q1iw8prfhdiw3h6i3dqpxb4ypy3cwd2qf77s";
  };

in

pkgs.stdenvNoCC.mkDerivation {
  name = "obsidian-${version}";
  version = version;
  src = pkgs.fetchurl {
    url = url;
    sha256 = sha256;
  };
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/share

    cp $src $out/share/obsidian.AppImage
    chmod +x $out/share/obsidian.AppImage

    mkdir -p $out/bin

    cat <<EOF > $out/bin/obsidian
    #!${pkgs.bash}/bin/bash
    ${pkgs.appimage-run}/bin/appimage-run $out/share/obsidian.AppImage
    EOF

    chmod +x $out/bin/obsidian

    mkdir -p $out/share/applications
    cp ${icon} $out/share/obsidian.png

    cat <<EOF > $out/share/applications/Obsidian.desktop
    [Desktop Entry]
    Name=Obsidian
    Comment=Obsidian Knowledge Base
    GenericName=Obsidian Knowledge Base
    Exec=$out/bin/obsidian
    Terminal=false
    Type=Application
    Icon=$out/share/obsidian.png
    EOF
  '';
}
