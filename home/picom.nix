# Some settings from https://pastebin.com/S8m1jnY3
{...}: {
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
      blur = {
        method = "dual_kawase";
        strength = 2;
      };
      invert-color-include = ["TAG_INVERT@:8c = 1"];
      no-fading-openclose = true;
    };

    fade = true;
    fadeDelta = 12;
    fadeSteps = [0.15 0.15];

    inactiveOpacity = 0.99;

    menuOpacity = 0.98;

    shadow = true;
    shadowExclude = [
      "n:e:Notification"
      "name = 'cpt_frame_xcb_window'" # Zoom screen sharing
      "class_g ?= 'zoom'" # Zoom screen sharing
    ];
    shadowOffsets = [(-15) (-15)];
    shadowOpacity = 0.7;

    opacityRules = [
      "100:_NET_WM_STATE@[0]:32a = '_NET_WM_STATE_FULLSCREEN'" # Exclude fullscreen windows from being transparent on focus
      "100:_NET_WM_STATE@[1]:32a = '_NET_WM_STATE_FULLSCREEN'" # From https://github.com/yshui/picom/issues/675
      "100:_NET_WM_STATE@[2]:32a = '_NET_WM_STATE_FULLSCREEN'"
      "100:_NET_WM_STATE@[3]:32a = '_NET_WM_STATE_FULLSCREEN'"
      "100:_NET_WM_STATE@[4]:32a = '_NET_WM_STATE_FULLSCREEN'"
      "80:class_i ?= 'rofi'"
      "80:class_g ?= 'i3bar'"
    ];
  };
}
