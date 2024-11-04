# Some settings from https://pastebin.com/S8m1jnY3
{...}: {
  services.picom = {
    activeOpacity = 0.95;

    enable = true;

    backend = "glx";

    settings = {
      blur = {
        method = "dual_kawase";
        strength = 4;
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
