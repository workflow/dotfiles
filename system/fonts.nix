{ pkgs, ... }:

let

  mkIosevka = { mode, variant, sha256, version ? "3.0.0-rc.7" }:
    let
      prefix = if isNull variant then "03-" else "";
      suffix = if isNull mode then "" else "-${mode}";
      name_ = if isNull variant then "iosevka${suffix}" else "iosevka${suffix}-${variant}";
      urlPrefix = "https://github.com/be5invis/Iosevka/releases/download";
    in
      pkgs.fetchzip {
        name = "${name_}-${version}";
        url = "${urlPrefix}/v${version}/${prefix}${name_}-${version}.zip";
        sha256 = sha256;
        postFetch = ''
          mkdir -p $out/share/fonts
          unzip -j $downloadedFile 'ttf/*.ttf' -d $out/share/fonts/$name
        '';
      };

  iosevka-term = mkIosevka {
    mode = "term";
    variant = null;
    sha256 = "13nbfif7qq8l27rd4nli93sis2al2aaza4rww98r10zfg39d6h7v";
  };

in

{
  fonts.fonts = [
    iosevka-term
    pkgs.hack-font
    pkgs.source-code-pro
  ];

  fonts.fontconfig = {
    enable = true;
    antialias = true;
    hinting.enable = true;
  };
}
