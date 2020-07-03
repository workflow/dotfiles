{ pkgs, ... }:

let

  functions = {
    start_tmux = ''
      if type tmux > /dev/null
        #if not inside a tmux session, and if no session is started, start a new session
        if test -z "$TMUX" ; and test -z $TERMINAL_CONTEXT
            tmux -2 attach; or tmux -2 new-session
        end
      end
    '';
  };

  plugins = [
    {
      name = "fish-ssh-agent";
      src = pkgs.fetchFromGitHub {
        owner = "danhper";
        repo = "fish-ssh-agent";
        rev = "ce90d80aa9549c626f9c5fc5a964536de015a192";
        sha256 = "03zj5g7dxkhqpp9lijxxlnyx4cc7nqpapj5iqfv7swavyximicyi";
      };
    }
  ];

  theme = ''
    set -g fish_color_autosuggestion 586e75
    set -g fish_color_cancel -r
    set -g fish_color_command 93a1a1
    set -g fish_color_comment 586e75
    set -g fish_color_cwd green
    set -g fish_color_cwd_root red
    set -g fish_color_end 268bd2
    set -g fish_color_error dc322f
    set -g fish_color_escape 00a6b2
    set -g fish_color_history_current --bold
    set -g fish_color_host normal
    set -g fish_color_match --background=blue
    set -g fish_color_normal normal
    set -g fish_color_operator 00a6b2
    set -g fish_color_param 839496
    set -g fish_color_quote 657b83
    set -g fish_color_redirection 6c71c4
    set -g fish_color_search_match bryellow --background=405555
    set -g fish_color_selection white --bold --background=black
    set -g fish_color_status red
    set -g fish_color_user brgreen
    set -g fish_color_valid_path --underline
    set -g fish_pager_color_completion B3A06D
    set -g fish_pager_color_description B3A06D
    set -g fish_pager_color_prefix cyan --underline
    set -g fish_pager_color_progress brwhite --background=cyan
  '';

  variables = ''
    set -g fish_key_bindings fish_default_key_bindings
    set fish_greeting  # disable greeting
  '';

in

{
  inherit functions;

  inherit plugins;

  shellInit = ''
    #eval (${pkgs.direnv}/bin/direnv hook fish)

    if test -e $HOME/.local-fishrc
      source $HOME/.local-fishrc
    end

    ${variables}
    ${theme}

    start_tmux
  '';
}
