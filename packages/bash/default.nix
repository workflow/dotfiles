{ pkgs, ... }:

let

  git-prompt-sh = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/git/git/4c86140027f4a0d2caaa3ab4bd8bfc5ce3c11c8a/contrib/completion/git-prompt.sh";
    sha256 = "0zs42vdr1ddr741zfym0nkdd4b6xrclinr24cpgkq7k70s9403ks";
  };

in

{
  programs.bash = {
    promptInit = ''
      source ${git-prompt-sh}
      export GIT_PS1_SHOWDIRTYSTATE=1
      export GIT_PS1_SHOWSTASHSTATE=1
      export GIT_PS1_SHOWUNTRACKEDFILES=1
      export GIT_PS1_SHOWUPSTREAM="auto"
      export GIT_PS1_SHOWCOLORHINTS=1
      export PROMPT_COMMAND='__git_ps1 "\[\033[$PROMPT_COLOR\][\u@\h: \w\033[0m" "\033[$PROMPT_COLOR]\\$\[\033[0m\] "'

      # Provide a nice prompt if the terminal supports it.
      if [ "$TERM" != "dumb" -o -n "$INSIDE_EMACS" ]; then
        PROMPT_COLOR="1;31m"
        let $UID && PROMPT_COLOR="1;32m"
        if [ -n "$INSIDE_EMACS" ]; then
          # Emacs term mode doesn't support xterm title escape sequence (\e]0;)
          PS1="\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
        else
          PS1="\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\\$\[\033[0m\] "
        fi
        if test "$TERM" = "xterm"; then
          PS1="\[\033]2;\h:\u:\w\007\]$PS1"
        fi
      fi
    '';
  };
}
