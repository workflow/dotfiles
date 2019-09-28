{ pkgs, ... }:

let

  git-prompt-sh = pkgs.fetchurl {
    url =
      "https://raw.githubusercontent.com/git/git/4c86140027f4a0d2caaa3ab4bd8bfc5ce3c11c8a/contrib/completion/git-prompt.sh";
    sha256 = "0zs42vdr1ddr741zfym0nkdd4b6xrclinr24cpgkq7k70s9403ks";
  };

in {
  programs.bash = {
    interactiveShellInit = ''
      export HISTSIZE=5000
      export HISTFILESIZE=5000
      export HISTCONTROL=ignoreboth:erasedups
      shopt -s histappend
      export PROMPT_COMMAND='history -a'

      if command -v fzf-share >/dev/null; then
        source "$(fzf-share)/key-bindings.bash"
      fi
    '';
    promptInit = ''
      source ${git-prompt-sh}
      export GIT_PS1_SHOWDIRTYSTATE=1
      export GIT_PS1_SHOWSTASHSTATE=1
      export GIT_PS1_SHOWUNTRACKEDFILES=1
      export GIT_PS1_SHOWUPSTREAM="auto"

      # Provide a nice prompt if the terminal supports it.
      if [ "$TERM" != "dumb" -o -n "$INSIDE_EMACS" ]; then
        PROMPT_COLOR="1;31m"
        let $UID && PROMPT_COLOR="1;32m"
        if [ -n "$INSIDE_EMACS" ]; then
          # Emacs term mode doesn't support xterm title escape sequence (\e]0;)
          PS1='\[\033[$PROMPT_COLOR\][\u@\h:\w\[\033[1;33m\]$(__git_ps1 " (%s)")\[\033[$PROMPT_COLOR\]]\\$\[\033[0m\] '
        else
          PS1='\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \w\a\]\u@\h:\w\[\033[1;33m\]$(__git_ps1 " (%s)")\[\033[$PROMPT_COLOR\]]\\$\[\033[0m\] '
        fi
        if test "$TERM" = "xterm"; then
          PS1="\[\033]2;\h:\u:\w\007\]$PS1"
        fi
      fi
    '';
  };
}
