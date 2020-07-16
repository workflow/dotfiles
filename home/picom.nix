{ pkgs, ... }:
{
  services.picom = {
    activeOpacity = "0.98";

    enable = true;

    inactiveDim = "0.1";

    inactiveOpacity = "0.98";

    #opacityRule = [
    #  "100:class_i ?= 'i3bar'"
    #];
  };
}
