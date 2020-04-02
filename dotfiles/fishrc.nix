{ pkgs, ... }:

let

  profile = pkgs.callPackage ./profile.nix {};

  extra = ''

    ${pkgs.lib.concatStringsSep "\n"
    (
      pkgs.lib.mapAttrsToList (k: v: "alias ${k} ${pkgs.lib.escapeShellArg v}")
        profile.aliases
    )}
  '';

  variables = ''
    set -g fish_key_bindings fish_default_key_bindings
    set fish_greeting  # disable greeting
  '';

  promptVariables = ''
    set -g __fish_git_prompt_show_informative_status 1
    set -g __fish_git_prompt_hide_untrackedfiles 1

    set -g __fish_git_prompt_color_branch magenta

    set -g __fish_git_prompt_showupstream "informative"
    set -g __fish_git_prompt_char_upstream_ahead "↑"
    set -g __fish_git_prompt_char_upstream_behind "↓"
    set -g __fish_git_prompt_char_upstream_prefix ""
    set -g __fish_git_prompt_color_upstream blue

    set -g __fish_git_prompt_char_stagedstate "•"
    set -g __fish_git_prompt_color_stagedstate green

    set -g __fish_git_prompt_char_dirtystate "•"
    set -g __fish_git_prompt_color_dirtystate yellow

    set -g __fish_git_prompt_char_untrackedfiles "•"
    set -g __fish_git_prompt_color_untrackedfiles red

    set -g __fish_git_prompt_char_invalidstate "✖"
    set -g __fish_git_prompt_color_invalidstate red

    set -g __fish_git_prompt_char_cleanstate "✔"
    set -g __fish_git_prompt_color_cleanstate green --bold

    set -g __fish_prompt_normal (set_color normal)
  '';

  theme = ''
    set -g fish_color_autosuggestion 586e75
    set -g fish_color_cancel \x2dr
    set -g fish_color_command 93a1a1
    set -g fish_color_comment 586e75
    set -g fish_color_cwd green
    set -g fish_color_cwd_root red
    set -g fish_color_end 268bd2
    set -g fish_color_error dc322f
    set -g fish_color_escape 00a6b2
    set -g fish_color_history_current \x2d\x2dbold
    set -g fish_color_host normal
    set -g fish_color_match \x2d\x2dbackground\x3dbrblue
    set -g fish_color_normal normal
    set -g fish_color_operator 00a6b2
    set -g fish_color_param 839496
    set -g fish_color_quote 657b83
    set -g fish_color_redirection 6c71c4
    set -g fish_color_search_match bryellow --background=405555
    set -g fish_color_selection white\x1e\x2d\x2dbold\x1e\x2d\x2dbackground\x3dbrblack
    set -g fish_color_status red
    set -g fish_color_user brgreen
    set -g fish_color_valid_path \x2d\x2dunderline
    set -g fish_pager_color_completion B3A06D
    set -g fish_pager_color_description B3A06D
    set -g fish_pager_color_prefix cyan\x1e\x2d\x2dunderline
    set -g fish_pager_color_progress brwhite\x1e\x2d\x2dbackground\x3dcyan
  '';

  fzf = {
    key-bindings = ''
      if command -s fzf-share >/dev/null
        source (fzf-share)/key-bindings.fish
      end
      fzf_key_bindings
    '';
  };

in

{ shellInit = ''
    eval (${pkgs.direnv}/bin/direnv hook fish)

    # export WORKON_HOME=$HOME/.virtualenvs
    # source ${pkgs.python37Packages.virtualenvwrapper}/bin/virtualenvwrapper_lazy.sh

    if test -e $HOME/.local-fishrc
      source $HOME/.local-fishrc
    end

    function nvminit
      unset -f npm
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    end

    function hs
      eval "nix-shell -p 'haskellPackages.ghcWithPackages (pkgs: with pkgs; [ $argv ])'"
    end

    function py
      eval "nix-shell -p 'python37.withPackages (pkgs: with pkgs; [ ipython $argv ])'"
    end

    function fish_user_key_bindings
      ${fzf.key-bindings}
    end

    # messes with emacs
    function fish_title
    end

    ${extra}
    ${variables}
    ${theme}
  '';
  promptInit = ''
    ${promptVariables}

    set -g __my_prompt_multiline 0

    function sp
      if test $__my_prompt_multiline = 0
        set -g __my_prompt_multiline 1
      else
        set -g __my_prompt_multiline 0
      end
    end

    function fish_prompt --description 'Write out the prompt'
      function _when_multiline -a str nl
        if test $__my_prompt_multiline = 1
          if test $nl = 1
            echo $str
          else
            echo -n $str
          end
        end
      end

      set -l last_status $status

      set_color green --bold
      _when_multiline "┌─╼ " 0
      set_color normal

      if jobs -q
        echo -n '⚙ '
      end

      if test -n "$IN_NIX_SHELL"
        echo -n "(nix-shell) "
      end

      set -l color_cwd
      set -l prefix
      set -l suffix
      switch "$USER"
        case root toor
          if set -q fish_color_cwd_root
            set color_cwd $fish_color_cwd_root
          else
            set color_cwd $fish_color_cwd
          end
          set suffix '#'
        case '*'
          set color_cwd $fish_color_cwd
          set suffix '$'
      end

      # PWD
      set_color $color_cwd
      echo -n (prompt_pwd)
      set_color normal

      printf '%s ' (__fish_vcs_prompt)

      _when_multiline "" 1
      set_color green --bold
      _when_multiline "└╼ " 0
      set_color normal

      if not test $last_status -eq 0
        set_color $fish_color_error --bold
      else
        set_color green --bold
      end

      echo -n "$suffix "

      set_color normal
    end
  '';
}
