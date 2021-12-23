{ config, lib, pkgs, ... }:
let
  # Colors from: https://github.com/Kthulu120/i3wm-themes/blob/master/Nature/.resources/.extend.Xresources
  color1 = "#162025";
  color2 = "#662b37";
  color3 = "#bfbfbf";

in
{
  programs.rofi = {
    enable = true;

    extraConfig = {
      bw = 1;
      columns = 2;
    };

    # theme = {
    #   colors = {
    #     rows = rec {
    #       normal = {
    #         background = color1;
    #         foreground = color3;
    #         backgroundAlt = color1;
    #         highlight = {
    #           background = color1;
    #           foreground = color2;
    #         };
    #       };
    #       active = normal;
    #       urgent = normal;
    #     };

    #     window = {
    #       background = color1;
    #       border = color2;
    #       separator = color2;
    #     };
    #   };

    #   separator = "solid";

    #   scrollbar = false;

    #   padding = 5;

    #   lines = 5;
    # };

    font = "Fira Code 12";

    package = pkgs.rofi.override {
      plugins = [ pkgs.rofi-calc pkgs.rofi-emoji ];
    };
  };
}
