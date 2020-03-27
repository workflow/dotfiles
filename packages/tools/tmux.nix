{ pkgs, ... }:

let

  tmux-themepack = pkgs.fetchFromGitHub {
    owner = "jimeh";
    repo = "tmux-themepack";
    rev = "7c59902f64dcd7ea356e891274b21144d1ea5948";
    sha256 = "1kl93d0b28f4gn1knvbb248xw4vzb0f14hma9kba3blwn830d4bk";
  };

in

{
  programs.tmux = {
    enable = true;
    shortcut = "s";
    keyMode = "vi";
    terminal = "screen-256color";
    extraTmuxConf = ''
      run-shell ${pkgs.tmuxPlugins.sensible.rtp}
      run-shell ${pkgs.tmuxPlugins.pain-control.rtp}
      run-shell ${pkgs.tmuxPlugins.sessionist.rtp}
      run-shell ${pkgs.tmuxPlugins.yank.rtp}
      source-file ${tmux-themepack}/powerline/default/blue.tmuxtheme

      set -g base-index 1
      setw -g pane-base-index 1
      setw -g monitor-activity on
      set -g renumber-windows on
      set-option -g allow-rename off
    '';
  };
}
