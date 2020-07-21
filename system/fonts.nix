{ pkgs, ... }:

{
  fonts.fonts = with pkgs; [
    font-awesome
    nerdfonts
  ];
}
