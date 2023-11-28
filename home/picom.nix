# Some settings from https://pastebin.com/S8m1jnY3
{ isNvidia, lib, pkgs, ... }:
{
  services.picom = {
    activeOpacity = 0.90;

    enable = true;

    # For NVIDIA, we can run with the simpler xrender backend,
    # which does not do vsync
    # Note: This may also need ForceFullCompositionPipeline in xorg.conf
    # See: https://github.com/chjj/compton/issues/227
    # backend = if isNvidia then "xrender" else "glx";
    backend = "glx";

    settings = {
      blur =
        {
          method = "dual_kawase";
          strength = 2;
        };
      no-fading-openclose = true;
      invert-color-include = [ "TAG_INVERT@:8c = 1" ];
    };

    fade = true;
    fadeDelta = 12;
    fadeSteps = [ 0.15 0.15 ];

    inactiveOpacity = 0.99;

    menuOpacity = 0.98;

    shadow = true;
    shadowExclude = [
      "n:e:Notification"
      "name = 'cpt_frame_xcb_window'" # Zoom screen sharing
      "class_g ?= 'zoom'" # Zoom screen sharing
    ];
    shadowOffsets = [ (-15) (-15) ];
    shadowOpacity = 0.7;

    opacityRules = [
      "80:class_i ?= 'rofi'"
      "80:class_g ?= 'i3bar'"
      "100:class_g ?= 'firefox'"
      "100:class_i ?= 'firefox'"
      "100:class_g ?= 'mpv'"
      "100:class_i ?= 'dota2'"
    ];
  };
}
