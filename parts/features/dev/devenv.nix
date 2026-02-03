# devenv.sh
{...}: {
  flake.modules.homeManager.devenv = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".local/share/devenv"
      ];
    };

    home.packages = [
      pkgs.devenv
    ];
  };
}
