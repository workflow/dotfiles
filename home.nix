{ pkgs, lib, ... }:

let

  home-dir = builtins.getEnv "HOME";

  myLib = import ./lib.nix { pkgs = pkgs; };
  tmpl = myLib.template;
  dotfile = path: import path { pkgs = pkgs; };
  terminalFont = "Hack 10.5";
  kbconfig = pkgs.callPackage ./packages/scripts/kbconfig.nix {};

in

{
  manual.html.enable = true;
  manual.manpages.enable = true;
  manual.json.enable = true;

  home.file = {
    # vim
    ".vimrc".text = dotfile ./dotfiles/vimrc.nix;

    # tmux
    ".tmux.conf".text = dotfile ./dotfiles/tmux-conf.nix;

    # git
    ".gitconfig".text = dotfile ./dotfiles/gitconfig.nix;

    # shells
    ".config/fish/config.fish".text = dotfile ./dotfiles/fishrc.nix;
    ".bashrc".text = dotfile ./dotfiles/bashrc.nix;
    ".zshrc".text = dotfile ./dotfiles/zshrc.nix;

    # others
    ".ghci".text = dotfile ./dotfiles/ghci.nix;
    ".xmonad-config.json".text = dotfile ./dotfiles/xmonad-config.nix;
  };

  systemd.user.services = {
    keyboard = {
      Install = {
        WantedBy = ["graphical-session.target"];
      };
      Unit = {
        Description = "Keyboard";
        After = "graphical-session-pre.target";
      };
      Service = {
        Type = "simple";
        ExecStart = "${kbconfig}/bin/kbconfig keep";
        RemainAfterExit = "no";
        Restart = "always";
        RestartSec = "5s";
      };
    };
  };

  programs.gnome-terminal = {
    enable = true;
    showMenubar = false;
    themeVariant = "dark";
    profile = {
      "a5914944-7bfe-4e88-8699-695bf6ce9f2c" = {
        default = true;
        visibleName = "Solarized Black";
        showScrollbar = false;
        font = terminalFont;
        colors = {
          foregroundColor = "rgb(161,183,185)";
          backgroundColor = "rgb(24,24,24)";
          boldColor = null;
          palette = [
            "rgb(3,29,35)"
            "rgb(220,50,47)"
            "rgb(133,153,0)"
            "rgb(181,137,0)"
            "rgb(38,139,210)"
            "rgb(211,54,130)"
            "rgb(42,161,152)"
            "rgb(238,232,213)"
            "rgb(31,124,149)"
            "rgb(203,75,22)"
            "rgb(133,153,0)"
            "rgb(181,137,0)"
            "rgb(38,139,210)"
            "rgb(211,54,130)"
            "rgb(42,161,152)"
            "rgb(253,246,227)"
          ];
        };
      };
      "b1dcc9dd-5262-4d8d-a863-c897e6d979b9" = {
        default = false;
        visibleName = "Solarized";
        showScrollbar = false;
        font = terminalFont;
        colors = {
          foregroundColor = "rgb(148,173,175)";
          backgroundColor = "rgb(0,43,54)";
          boldColor = null;
          palette = [
            "rgb(7,54,66)"
            "rgb(220,50,47)"
            "rgb(133,153,0)"
            "rgb(181,137,0)"
            "rgb(38,139,210)"
            "rgb(211,54,130)"
            "rgb(42,161,152)"
            "rgb(238,232,213)"
            "rgb(23,96,115)"
            "rgb(203,75,22)"
            "rgb(133,153,0)"
            "rgb(181,137,0)"
            "rgb(38,139,210)"
            "rgb(211,54,130)"
            "rgb(42,161,152)"
            "rgb(253,246,227)"
          ];
        };
      };
      "71fe2833-7417-43da-8459-008eb2f9e115" = {
        default = false;
        visibleName = "Light";
        showScrollbar = false;
        font = terminalFont;
        colors = {
          foregroundColor = "rgb(35,35,35)";
          backgroundColor = "rgb(240,255,240)";
          boldColor = null;
          palette = [
            "rgb(0,0,0)"
            "rgb(205,0,0)"
            "rgb(0,197,0)"
            "rgb(205,205,0)"
            "rgb(0,0,238)"
            "rgb(205,0,205)"
            "rgb(0,205,205)"
            "rgb(229,229,229)"
            "rgb(127,127,127)"
            "rgb(231,0,0)"
            "rgb(0,205,0)"
            "rgb(218,218,0)"
            "rgb(92,92,255)"
            "rgb(255,0,255)"
            "rgb(0,201,201)"
            "rgb(255,255,255)"
          ];
        };
      };
    };
  };
}
