{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = false;
    packages = [
      pkgs.fira-code
      pkgs.fira-code-symbols
      pkgs.dejavu_fonts
      pkgs.font-awesome_4
      pkgs.font-awesome_5
      pkgs.font-awesome_6
      (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })
      pkgs.noto-fonts-color-emoji # emoji font
    ];
    fontconfig = {
      defaultFonts = {
        sansSerif = [ "DejaVu Sans" ];
        serif = [ "DejaVu Serif" ];
        monospace = [ "Fira Code" ];
      };
    };
  };
}
