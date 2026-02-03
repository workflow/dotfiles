# Audible liberator
{...}: {
  flake.modules.homeManager.libation = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        "Libation"
        ".local/share/Libation"
      ];
    };

    home.packages = [pkgs.libation];
  };
}
