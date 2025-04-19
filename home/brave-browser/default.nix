{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      ".config/BraveSoftware"
      ".cache/BraveSoftware"
    ];
  };

  home.packages = [
    pkgs.brave
  ];

  home.sessionVariables = {
    BROWSER = "brave --enable-features='VaapiVideoDecoder,VaapiVideoEncoder' --enable-raw-draw --password-store=seahorse";
    DEFAULT_BROWSER = "brave --enable-features='VaapiVideoDecoder,VaapiVideoEncoder' --enable-raw-draw --password-store=seahorse";
  };
}
