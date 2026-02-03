# Calculator
{...}: {
  flake.modules.homeManager.qalculate = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".config/qalculate"
        ".local/share/qalculate"
      ];
    };

    home.packages = [
      pkgs.qalculate-gtk
    ];
  };
}
