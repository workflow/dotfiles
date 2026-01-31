{...}: {
  flake.modules.homeManager.rofimoji = {pkgs, ...}: {
    home.packages = [
      pkgs.rofimoji
      pkgs.wtype
    ];

    xdg.configFile."rofimoji.rc".source = ./rofimoji.rc;
  };
}
