# Some settings from https://pastebin.com/S8m1jnY3
{ pkgs, ... }:
{
  services.picom = {
    activeOpacity = "0.98";

    # For NVIDIA, we can run with the simpler xrender backend,
    # which does not do vsync
    # Note: This will also need ForceFullCompositionPipeline in xorg.conf
    # See: https://github.com/chjj/compton/issues/227
    #backend = "xrender";

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

    shadow = true;
    shadowExclude = [ "n:e:Notification" ];
    shadowOffsets = [ (-15) (-15) ];
    shadowOpacity = "0.7";

    opacityRule = [
      "80:class_i ?= 'rofi'"
    ];
  };
}
