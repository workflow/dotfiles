{...}: {
  flake.modules.homeManager.rofimoji = {pkgs, ...}: {
    home.packages = [
      pkgs.rofimoji
      pkgs.wtype # insert emojis directly
    ];

    xdg.configFile."rofimoji.rc".source = ./rofimoji.rc;
  };
}
