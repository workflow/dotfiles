{ pkgs }:

let

  launcher = [
    "rofi -modi drun,run -show drun"
    "-matching fuzzy -no-levenshtein-sort -sort"
    "-theme lb -show-icons -kb-mode-next Alt+m"
  ];

  config = {
    terminal = "gnome-terminal";
    launcher = pkgs.lib.concatStringsSep " " launcher;
    screensaver = "i3lock-fancy -p";
    hasMediaKeys = true;
    useXmobar = false;
    borderWidth = 2;
    normalBorderColor = "#27444c";
    focusedBorderColor = "#268bd2";
    windowView = "GreedyView";
  };

in

builtins.toJSON config
