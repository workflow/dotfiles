# Some settings from https://pastebin.com/S8m1jnY3
{ lib, pkgs, ... }:
let
  sysconfig = (import <nixpkgs/nixos> { }).config;
  isNvidia = builtins.elem "nvidia" sysconfig.services.xserver.videoDrivers;
in
{
  services.picom = {
    activeOpacity = "0.98";

    enable = true;

    # For NVIDIA, we can run with the simpler xrender backend,
    # which does not do vsync
    # Note: This may also need ForceFullCompositionPipeline in xorg.conf
    # See: https://github.com/chjj/compton/issues/227
    backend = if isNvidia then "xrender" else "glx";

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
      "100:class_i ?= 'dota2'"
    ];
  };
}
