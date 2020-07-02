{ pkgs }:

let

  # TODO: Move themes and plugins to home-manager
  tmux-themepack = pkgs.fetchFromGitHub {
    owner = "jimeh";
    repo = "tmux-themepack";
    rev = "7c59902f64dcd7ea356e891274b21144d1ea5948";
    sha256 = "1kl93d0b28f4gn1knvbb248xw4vzb0f14hma9kba3blwn830d4bk";
  };

  theme = ''
    source-file ${tmux-themepack}/powerline/default/green.tmuxtheme
  '';

in

''
  #run-shell ${pkgs.tmuxPlugins.sensible.rtp}
  #run-shell ${pkgs.tmuxPlugins.pain-control.rtp}
  #run-shell ${pkgs.tmuxPlugins.sessionist.rtp}
  #run-shell ${pkgs.tmuxPlugins.yank.rtp}

  ${theme}

  set  -g default-terminal "screen-256color"
  set  -g base-index      1
  setw -g pane-base-index 1

  # TODO: Replace with yank plugin?
  bind P paste-buffer
  bind-key -T copy-mode-vi v send-keys -X begin-selection
  bind-key -T copy-mode-vi y send-keys -X copy-selection
  bind-key -T copy-mode-vi r send-keys -X rectangle-selection

  # TODO: Use parcellite instead of xclip?
  bind -T copy-mode-vi y send -X copy-pipe "xclip -i -sel p -f | xclip -i -sel c" \: display-message "copied to system clipboard"

  # VIM Style split panes
  bind v split-window -h
  bind s split-window -v
  unbind '"'
  unbind %

  # Match Webstorm/Vim window mgmt
  bind c kill-pane
  bind w select-pane -t :.+
  bind o break-pane

''
