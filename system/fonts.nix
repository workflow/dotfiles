{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = false;
    packages = [
      pkgs.fira-code
      pkgs.fira-code-symbols
      pkgs.font-awesome_4
      pkgs.font-awesome_5
      pkgs.font-awesome_6
      (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })
      pkgs.noto-fonts-color-emoji # emoji font
    ];
  };
}
