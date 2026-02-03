{...}: {
  flake.modules.homeManager.urxvt = {pkgs, ...}: {
    programs.urxvt = {
      enable = true;

      # Perl extensions
      extraConfig = {
        perl-ext-common = "default,matcher,resize-font,vtwheel,keyboard-select,-searchable-scrollback";
        # Matcher (clickable URLs)
        url-launcher = "${pkgs.xdg-utils}/bin/xdg-open";
        "matcher.button" = 1;
        # Messes with CTRL+SHIFT Keybindings, see https://wiki.archlinux.org/index.php/Rxvt-unicode#Perl_extensions
        iso14755_52 = false;
        # https://github.com/muennich/urxvt-perls#keyboard-select
        "keyboard-select.clipboard" = true;
      };

      fonts = ["xft:FiraCode Nerd Font Mono:size=8"];
      iso14755 = false;

      keybindings = {
        "Shift-Control-C" = "eval:selection_to_clipboard";
        "Shift-Control-V" = "eval:paste_clipboard";
        "Meta-Escape" = "perl:keyboard-select:activate";
        "Meta-Shift-S" = "perl:keyboard-select:search";
      };

      package = pkgs.rxvt-unicode;
      scroll.bar.enable = false;
    };
  };
}
