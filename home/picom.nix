# Some settings from https://pastebin.com/S8m1jnY3
{ isNvidia, lib, pkgs, ... }:
{
  services.picom = {
    activeOpacity = 0.98;

    enable = true;

    # For NVIDIA, we can run with the simpler xrender backend,
    # which does not do vsync
    # Note: This may also need ForceFullCompositionPipeline in xorg.conf
    # See: https://github.com/chjj/compton/issues/227
    backend = if isNvidia then "xrender" else "glx";

    settings = {
      no-fading-openclose = true;
    };

    fade = true;
    fadeDelta = 12;
    fadeSteps = [ 0.15 0.15 ];

    inactiveOpacity = 0.95;

    menuOpacity = 0.98;

    shadow = true;
    shadowExclude = [ "n:e:Notification" ];
    shadowOffsets = [ (-15) (-15) ];
    shadowOpacity = 0.7;

    opacityRules = [
      "80:class_i ?= 'rofi'"
      "100:class_i ?= 'dota2'"
    ];
  };
}
