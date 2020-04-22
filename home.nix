{ pkgs, lib, ... }:

let

  profile = pkgs.callPackage ./dotfiles/profile.nix {};

  kbconfig = pkgs.callPackage ./packages/tools/kbconfig.nix {};
  fishrc = pkgs.callPackage ./dotfiles/fishrc.nix {};

  scripts = pkgs.callPackage ./dotfiles/scripts.nix {};
  autostart = pkgs.callPackage ./dotfiles/autostart.nix {};

in

{
  # home-manager manual
  manual.manpages.enable = true;
  manual.html.enable = true;

  home = {
    file = {
      # vim
      ".vimrc".text = pkgs.callPackage ./dotfiles/vimrc.nix {};

      # tmux & tmate
      ".tmux.conf".text = pkgs.callPackage ./dotfiles/tmux-conf.nix { tmate = false; };
      ".tmate.conf".text = pkgs.callPackage ./dotfiles/tmux-conf.nix { tmate = true; };

      # ~/bin
      "bin/xfce-manage" = { text = scripts.xfce-manage; executable = true; };
      "bin/em" = { text = scripts.em; executable = true; };
      "bin/session-quit" = { text = scripts.session-quit; executable = true; };
      "bin/cookie" = { text = scripts.cookie; executable = true; };
      "bin/gen-gitignore" = { text = scripts.gen-gitignore; executable = true; };

      # xfce autostart
      ".config/autostart/xmonad-init.desktop".text = autostart.xmonad-init;

      # others
      ".config/bat/config".text = ''
        --theme="TwoDark"
        --style="header,grid"
      '';
      ".config/dunst/dunstrc".source = ./dotfiles/dunstrc;
      ".config/rofi/config.rasi".source = ./dotfiles/rofi;
      ".ghci".source = ./dotfiles/ghci;
    };
    sessionVariables = {
      PATH = "$HOME/.local/bin:$HOME/bin:$PATH";
      EDITOR = "vim";
      LESS = "-r";
    };
  };

  systemd.user.services = {
    keyboard = {
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
      Unit = {
        Description = "Keyboard";
        After = "graphical-session-pre.target";
      };
      Service = {
        Type = "simple";
        ExecStart = "${kbconfig}/bin/kbconfig --ctrl-esc-fg";
        RemainAfterExit = "no";
        Restart = "always";
        RestartSec = "5s";
      };
    };
    wiki = {
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
      Unit = {
        Description = "Wiki";
        After = "graphical-session-pre.target";
      };
      Service = {
        Type = "simple";
        ExecStart =
          "${pkgs.python37}/bin/python -m http.server 23456 -b localhost -d %h/Dropbox/emacs/deft";
        RemainAfterExit = "no";
        Restart = "always";
        RestartSec = "3s";
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "Alexandros Peitsinis";
    userEmail = "alexpeitsinis@gmail.com";
    aliases = {
      ls = ''log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --date=relative'';
      lr = ''log --pretty=format:"%C(yellow)%h\\ %ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --date=relative'';
      ll = "log --graph --decorate --pretty=oneline --abbrev-commit";
      ld = ''log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --numstat'';
      lla = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
      c = "commit --verbose";
      a = "add -A";
      pr = ''!git pull --rebase "$(git rev-parse --abbrev-ref HEAD)"'';
      fl = "log -u";
      count = "shortlog -s -n --all";
      squash = "rebase -i HEAD^^";
      delremote = "push origin --delete";
    };
    extraConfig = {
      core = {
        editor = "vim";
      };
      credential.helper = "store";
    };
    ignores = [
      ".projectile"
      ".dir-locals.el"
      "*.swp"
    ];
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = fishrc.shellInit;
    promptInit = fishrc.promptInit;
    shellAliases = profile.aliases;
  };

  programs.bash = {
    enable = true;
    historyControl = [ "erasedups" "ignoredups" "ignorespace" ];
    shellOptions = [
      "histappend"
      "extglob"
      "globstar"
      "checkjobs"
    ];
    shellAliases = profile.aliases;
    initExtra = pkgs.callPackage ./dotfiles/bashrc.nix {};
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = false;
    enableCompletion = true;
    history = {
      size = 50000;
      save = 500000;
      ignoreDups = true;
      share = true;
    };
    initExtra = pkgs.callPackage ./dotfiles/zshrc.nix {};
    shellAliases = profile.aliases;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.gnome-terminal = {
    enable = true;
    showMenubar = false;
    themeVariant = "dark";
    profile =
      let
        dark = {
          default = false;
          visibleName = "Dark";
          showScrollbar = false;
          font = "Hack 10.5";
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
        light = {
          default = false;
          visibleName = "Light";
          showScrollbar = false;
          font = "Hack 10.5";
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
      in
        {
          "a5914944-7bfe-4e88-8699-695bf6ce9f2c" = dark // { default = true; };
          "cd0124dc-173f-430a-a5f0-4eb1847845f4" = dark // {
            visibleName = "Dark large";
            font = "Hack 12";
          };
          "71fe2833-7417-43da-8459-008eb2f9e115" = light;
          "636893b8-eb99-4361-a0ff-fe7b5e61e4c7" = light // {
            visibleName = "Light large";
            font = "Hack 12";
          };
        };
  };
}
