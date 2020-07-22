{ pkgs, ... }:

{
  fonts.fonts = with pkgs; [
    fira-code
    fira-code-symbols
    font-awesome_4
    nerdfonts
  ];
}
