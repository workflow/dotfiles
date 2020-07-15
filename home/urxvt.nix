{ pkgs, ... }:

{
  programs.urxvt = {
    enable = true;

    extraConfig = {
      perl-ext-common = "default,matcher";
      url-launcher = "${pkgs.xdg_utils}/bin/xdg-open";
      "matcher.button" = 1;
    };

    fonts = [ "xft:Inconsolata:size=9" ];

    keybindings = { 
      "Shift-Control-C" = "eval:selection_to_clipboard";
      "Shift-Control-V" = "eval:paste_clipboard";
    };

    package = pkgs.rxvt_unicode-with-plugins;

    scroll.bar.enable = false;
  };
}
