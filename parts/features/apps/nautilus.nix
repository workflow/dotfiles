# Gnome File Manager
{...}: {
  flake.modules.homeManager.nautilus = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".config/nautilus"
        ".local/share/nautilus"
      ];
    };

    home.packages = [pkgs.nautilus];
  };
}
