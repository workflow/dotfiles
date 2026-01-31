{...}: {
  flake.modules.homeManager.mullvad-browser = {lib, osConfig, pkgs, ...}: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".mullvad"
      ];
    };

    home.packages = [
      pkgs.mullvad-browser
    ];
  };
}
