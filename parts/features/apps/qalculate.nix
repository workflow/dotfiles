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

    programs.qalculate = {
      enable = true;
      package = pkgs.qalculate-gtk;
    };
  };
}
