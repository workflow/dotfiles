{ pkgs, ... }:

let

  iosevka =
    let
      ver = "3.0.0-rc.7";
      term = true;
      var = null;
      tm = if term then "-term" else "";
      nm = if isNull var then "iosevka${tm}" else "iosevka${tm}-${var}";
      pref = if isNull var then "03-" else "";
    in
      pkgs.fetchzip {
        name = "${nm}-${ver}";
        url = "https://github.com/be5invis/Iosevka/releases/download/v${ver}/${pref}${nm}-${ver}.zip";
        sha256 = "13nbfif7qq8l27rd4nli93sis2al2aaza4rww98r10zfg39d6h7v";
        postFetch = ''
          mkdir -p $out/share/fonts
          unzip -j $downloadedFile 'ttf/*.ttf' -d $out/share/fonts/$name
        '';
      };

in

{
  fonts.fonts = [
    pkgs.source-code-pro
    pkgs.hack-font
    iosevka
  ];

  fonts.fontconfig = {
    enable = true;
    antialias = true;
    hinting.enable = true;
  };
}
