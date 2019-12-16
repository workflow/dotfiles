{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shortcut = "s";
    keyMode = "vi";
    terminal = "screen-256color";
    extraTmuxConf = ''
      bind-key \ split-window -h -c "#{pane_current_path}"
      bind-key - split-window -c "#{pane_current_path}"
      unbind '"'
      unbind %

      bind -n M-h select-pane -L
      bind -n M-l select-pane -R
      bind -n M-k select-pane -U
      bind -n M-j select-pane -D
      bind -n M-o select-pane -t :.+

      set -g base-index 1
      setw -g pane-base-index 1
      setw -g monitor-activity on
      set -g visual-activity on
      set -g renumber-windows on
      set-option -g allow-rename off

      set -g status-bg colour236
      set -g status-fg colour252
      # set -g pane-border-fg colour242
      # set -g pane-active-border-fg "#2aa1ae"
      set -g status-left '#[fg=colour075][#S]#[default] '
      # setw -g window-status-current-attr bold
      # set-window-option -g window-status-current-fg colour235
      # set-window-option -g window-status-current-bg colour032
      set-option -g status-right '#[fg=colour032]#H#[default] │ %d/%m/%y %H:%M '

      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection
      bind-key -T copy-mode-vi r send-keys -X rectangle-toggle

      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel '${pkgs.xclip}/bin/xclip -in -selection clipboard'
    '';
  };
}
