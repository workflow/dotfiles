{ pkgs, ... }:
{
  home.packages = [ pkgs.rofimoji ];

  xdg.configFile."rofimoji.rc".source = ./rofimoji.rc;
}
