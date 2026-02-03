# Linux devices manager for the Logitech Unifying Receiver
{...}: {
  flake.modules.homeManager.solaar = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [".config/solaar"];
    };

    home.packages = [
      pkgs.hicolor-icon-theme
      pkgs.solaar
    ];
  };
}
