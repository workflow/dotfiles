{...}: {
  flake.modules.homeManager.bitwarden = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".config/Bitwarden"
      ];
    };

    home.packages = [
      pkgs.bitwarden-desktop
      pkgs.bitwarden-cli
    ];
  };
}
