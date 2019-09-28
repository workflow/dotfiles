{ ... }:

{
  programs.tmux = {
    enable = true;
    shortcut = "s";
    extraTmuxConf = ''
      bind-key \ split-window -h -c "#{pane_current_path}"
      bind-key - split-window -c "#{pane_current_path}"
      unbind '"'
      unbind %

      bind -n M-h select-pane -L
      bind -n M-l select-pane -R
      bind -n M-k select-pane -U
      bind -n M-j select-pane -D
    '';
  };
}
