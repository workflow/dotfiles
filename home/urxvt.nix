{ pkgs, ... }:

{
  programs.urxvt = {
    enable = true;

    extraConfig = {
      # Perl extensions
      perl-ext-common = "default,matcher,resize-font,vtwheel";

      # Matcher (clickable URLs)
      url-launcher = "${pkgs.xdg_utils}/bin/xdg-open";
      "matcher.button" = 1;

      # Messes with CTRL+SHIFT Keybindings, see https://wiki.archlinux.org/index.php/Rxvt-unicode#Perl_extensions
      iso14755_52 = "false";
    };

    fonts = [ "xft:Fira Code Nerd Font:size=8" "xft:Inconsolata:size=8" ];

    # Messes with CTRL+SHIFT Keybindings, see https://wiki.archlinux.org/index.php/Rxvt-unicode#Perl_extensions
    iso14755 = false;

    keybindings = { 
      "Shift-Control-C" = "eval:selection_to_clipboard";
      "Shift-Control-V" = "eval:paste_clipboard";
    };

    package = pkgs.rxvt_unicode-with-plugins;

    scroll.bar.enable = false;
  };
}
