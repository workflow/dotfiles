# Ebook reader
{...}: {
  flake.modules.homeManager.calibre = {
    osConfig,
    lib,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        "Calibre Library"
        ".config/calibre"
        ".cache/calibre"
      ];
    };

    programs.calibre.enable = true;
  };
}
