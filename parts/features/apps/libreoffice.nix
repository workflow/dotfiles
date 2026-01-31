{...}: {
  flake.modules.homeManager.libreoffice = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".config/libreoffice"
      ];
    };

    home.packages = [
      pkgs.libreoffice
    ];
  };
}
