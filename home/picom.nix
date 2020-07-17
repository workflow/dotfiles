{ pkgs, ... }:
{
  services.picom = {
    activeOpacity = "0.98";

    enable = true;

    fade = true;
    fadeDelta = 2;

    inactiveDim = "0.1";

    inactiveOpacity = "0.98";

    opacityRule = [
      "80:class_i ?= 'rofi'"
    ];
  };
}
