{ pkgs, tmate ? false }:

let

  tmux-themepack = pkgs.fetchFromGitHub {
    owner = "jimeh";
    repo = "tmux-themepack";
    rev = "7c59902f64dcd7ea356e891274b21144d1ea5948";
    sha256 = "1kl93d0b28f4gn1knvbb248xw4vzb0f14hma9kba3blwn830d4bk";
  };

  theme = if tmate then ''
    set -g status-justify centre
    set -g status-left "#S #[fg=green]#(echo $USER) #[default]"
    set -g status-left-length 20
    set -g status-left-style default
    set -g status-right-length 140
    set -g status-right-style default
    set -g status-style fg=colour136,bg=colour236
    set-window-option -g window-status-fg colour244
    set-window-option -g window-status-bg default
    set-window-option -g window-status-current-fg colour166
    set-window-option -g window-status-current-bg default
  '' else ''
    source-file ${tmux-themepack}/powerline/default/green.tmuxtheme
  '';

in

''
  run-shell ${pkgs.tmuxPlugins.sensible.rtp}
  run-shell ${pkgs.tmuxPlugins.pain-control.rtp}
  run-shell ${pkgs.tmuxPlugins.sessionist.rtp}
  run-shell ${pkgs.tmuxPlugins.yank.rtp}

  ${theme}

  set  -g default-terminal "screen-256color"
  set  -g base-index      1
  setw -g pane-base-index 1
  setw -g aggressive-resize off
  setw -g clock-mode-style  12
  set  -s escape-time       0
  set  -g history-limit     2000
  setw -g monitor-activity on
  set  -g renumber-windows on
  set-option -g allow-rename off

  set -g status-keys vi
  set -g mode-keys   vi

  unbind C-b
  set -g prefix C-s
  bind s send-prefix
  bind C-s last-window
''
