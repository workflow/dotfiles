{ pkgs, lib, ... }:

let

  profile = pkgs.callPackage ./dotfiles/profile.nix {};
  colors = import ./assets/colors.nix;

  kbconfig = pkgs.callPackage ./packages/tools/kbconfig.nix {};
  fishrc = pkgs.callPackage ./dotfiles/fishrc.nix {};

  scripts = pkgs.callPackage ./dotfiles/scripts.nix {};
  autostart = pkgs.callPackage ./dotfiles/autostart.nix {};

  i3lock-wrap = pkgs.callPackage ./packages/tools/i3lock-wrap {};
  lock-cmd = "${i3lock-wrap}/bin/i3lock-wrap";

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
      "bin/em" = { text = scripts.em; executable = true; };
      "bin/session-quit" = { text = scripts.session-quit; executable = true; };
      "bin/cookie" = { text = scripts.cookie; executable = true; };
      "bin/gen-gitignore" = { text = scripts.gen-gitignore; executable = true; };

      # others
      ".config/rofi/config.rasi".source = ./dotfiles/rofi;
      ".ghci".source = ./dotfiles/ghci;
      ".local/share/applications/org-protocol.desktop".source = ./dotfiles/org-protocol.desktop;
    };
    sessionVariables = {
      PATH = "$HOME/.local/bin:$HOME/bin:$PATH";
      EDITOR = "vim";
      LESS = "-r";
    };
    stateVersion = "20.03";
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
    xautolock = {
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
      Unit = {
        Description = "xautolock";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = pkgs.lib.concatStringsSep " " [
          "${pkgs.xautolock}/bin/xautolock"
          "-time 10"
          "-locker ${lock-cmd}"
          "-detectsleep"
          "-corners 0--0 -cornersize 30"
        ];
        Restart = "always";
      };
    };
    xss-lock = {
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
      Unit = {
        Description = "xss-lock";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = pkgs.lib.concatStringsSep " " [
          "${pkgs.xss-lock}/bin/xss-lock"
          "--"
          "${lock-cmd}"
        ];
        Restart = "always";
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
          "${pkgs.python37}/bin/python -m http.server 25001 -b localhost -d %h/org-roam-publish";
        RemainAfterExit = "no";
        Restart = "always";
        RestartSec = "3s";
      };
    };
    notes-git-push = {
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
      Unit = {
        Description = "notes-git-push";
        After = "graphical-session-pre.target";
      };
      Service = {
        Type = "oneshot";
        ExecStart = "%h/Dropbox/emacs/org/.autocommit";
      };
    };
  };

  systemd.user.timers = {
    notes-git-push-timer = {
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
      Unit = {
        Description = "notes-git-push-timer";
        Requires = "notes-git-push.service";
      };
      Timer = {
        Unit = "notes-git-push.service";
        OnCalendar = "*:0/30"; # every 30 mins, 'hourly' = every 1 hr
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

  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      style = "header,grid";
    };
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        font = "Iosevka Term 11.5";
        markup = true;
        plain_text = false;
        format = "<b>%s</b>\\n%b";
        sort = false;
        indicate_hidden = true;
        alignment = "center";
        bounce_freq = 0;
        show_age_threshold = -1;
        word_wrap = true;
        ignore_newline = false;
        stack_duplicates = false;
        hide_duplicates_count = true;
        geometry = "300x50-15+49";
        shrink = false;
        idle_threshold = 0;
        monitor = 0;
        follow = "mouse";
        sticky_history = true;
        history_length = 15;
        show_indicators = false;
        line_height = 3;
        separator_height = 4;
        padding = 6;
        horizontal_padding = 8;
        separator_color = "frame";
        frame_width = 3;
        frame_color = colors.green;
      };
      shortcuts = {
        close = "mod1+F5";
        close_all = "mod1+F6";
        history = "mod1+F7";
      };
      urgency_low = {
        frame_color = colors.cyan;
        foreground = colors.cyan;
        background = colors.bg;
        timeout = 4;
      };
      urgency_normal = {
        frame_color = colors.green;
        foreground = colors.green;
        background = colors.bg;
        timeout = 6;
      };
      urgency_critical = {
        frame_color = colors.orange;
        foreground = colors.orange;
        background = colors.bg;
        timeout = 8;
      };
      history_ignore_app = {
        appname = "history-ignore";
        history_ignore = true;
      };
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/org-protocol" = "org-protocol.desktop";
      "text/html" = "google-chrome.desktop";
      "x-scheme-handler/http" = "google-chrome.desktop";
      "x-scheme-handler/https" = "google-chrome.desktop";
      "application/pdf" = "org.gnome.Evince.desktop";
      "audio/mpeg" = "vlc.desktop";
    };
  };

  programs.gnome-terminal = {
    enable = true;
    showMenubar = false;
    themeVariant = "dark";
    profile =
      let
        mkFont = { name, size }: "${name} ${builtins.toString size}";
        smallFont = mkFont {
          name = "Source Code Pro Medium";
          size = 10.5;
        };
        largeFont = mkFont {
          name = "Source Code Pro Medium";
          size = 11;
        };
        dark = {
          default = false;
          visibleName = "Dark";
          showScrollbar = false;
          font = smallFont;
          colors = {
            foregroundColor = "#d2e9eb";
            backgroundColor = "#0a0a0a";
            boldColor = null;
            highlight = {
              background = "#88c0d0";
              foreground = "#0a0a0a";
            };
            palette = [
              "#252525"
              "#ff8059"
              "#44bc44"
              "#eecc00"
              "#33beff"
              "#f78fe7"
              "#00d3d0"
              "#d0d0d0"
              "#808080"
              "#ff8059"
              "#44bc44"
              "#eecc00"
              "#33beff"
              "#f78fe7"
              "#00d3d0"
              "#e0e0e0"
            ];
          };
        };
        lowContrast = {
          default = false;
          visibleName = "Low Contrast";
          showScrollbar = false;
          font = smallFont;
          colors = {
            foregroundColor = "#dcdccc";
            backgroundColor = "#3f3f3f";
            boldColor = null;
            highlight = {
              background = "#8fb28f";
              foreground = "#3f3f3f";
            };
            palette = [
              "#505050"
              "#cc9393"
              "#7f9f7f"
              "#e3ceab"
              "#dfaf8f"
              "#dc8cc3"
              "#93e0e3"
              "#dcdccc"
              "#909090"
              "#cc9393"
              "#7f9f7f"
              "#e3ceab"
              "#dfaf8f"
              "#dc8cc3"
              "#93e0e3"
              "#dcdccc"
            ];
          };
        };
        light = {
          default = false;
          visibleName = "Light";
          showScrollbar = false;
          font = smallFont;
          colors = {
            foregroundColor = "#101010";
            backgroundColor = "#fafafa";
            boldColor = null;
            highlight = {
              background = "#0073A4";
              foreground = "#fafafa";
            };
            palette = [
              "#202020"
              "#b20000"
              "#007200"
              "#925f00"
              "#033dcc"
              "#80114d"
              "#0073a4"
              "#8b8b8b"
              "#444444"
              "#b20000"
              "#007200"
              "#925f00"
              "#033dcc"
              "#80114d"
              "#0073a4"
              "#a6a6a6"
            ];
          };
        };
      in
        {
          "a5914944-7bfe-4e88-8699-695bf6ce9f2c" = dark // { default = true; };
          "cd0124dc-173f-430a-a5f0-4eb1847845f4" = dark // {
            visibleName = dark.visibleName + " large";
            font = largeFont;
          };
          "cc0cc7dc-f63e-4fe6-909c-b7c4509a1df2" = lowContrast;
          "f91c4e9c-676e-4225-a756-fba7149f447f" = lowContrast // {
            visibleName = lowContrast.visibleName + " large";
            font = largeFont;
          };
          "71fe2833-7417-43da-8459-008eb2f9e115" = light;
          "636893b8-eb99-4361-a0ff-fe7b5e61e4c7" = light // {
            visibleName = light.visibleName + " large";
            font = largeFont;
          };
        };
  };
}
