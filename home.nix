{ pkgs, lib, ... }:

let

  profile = pkgs.callPackage ./dotfiles/profile.nix {};

  terminalFont = "Hack 10.5";
  kbconfig = pkgs.callPackage ./packages/scripts/kbconfig.nix {};
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
      "bin/em" = { text = scripts.emacsclient; executable = true; };
      "bin/xfce-init" = { text = scripts.xfce-init; executable = true; };
      "bin/dpi" = { text = scripts.dpi; executable = true; };
      "bin/gen-gitignore" = { text = scripts.gen-gitignore; executable = true; };

      # xfce autostart
      ".config/autostart/xfce-init.desktop".text = autostart.xfce-init;

      # others
      ".ghci".text = pkgs.callPackage ./dotfiles/ghci.nix {};
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
        ExecStart = "${kbconfig}/bin/kbconfig keep";
        RemainAfterExit = "no";
        Restart = "always";
        RestartSec = "5s";
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
    # enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    fileWidgetCommand = "${pkgs.fd}/bin/fd --type f";
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
