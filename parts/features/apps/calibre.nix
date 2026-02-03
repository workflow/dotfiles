# Ebook reader
{...}: {
  flake.modules.homeManager.calibre = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        "Calibre Library"
        ".config/calibre"
        ".cache/calibre"
      ];
    };

    home.packages = [pkgs.calibre];
  };
}
