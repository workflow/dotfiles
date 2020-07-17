# Some settings from https://pastebin.com/S8m1jnY3
{ pkgs, ... }:
{
  services.picom = {
    activeOpacity = "0.98";

    enable = true;

    extraOptions = ''
      no-fading-openclose = true;
    '';

    fade = true;
    fadeDelta = 12;
    fadeSteps = [ "0.15" "0.15" ];

    inactiveDim = "0.1";

    inactiveOpacity = "0.98";

    menuOpacity = "0.98";
    opacityRule = [
      "80:class_i ?= 'rofi'"
    ];
  };
}
