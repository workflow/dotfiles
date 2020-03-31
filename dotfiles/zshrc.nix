{ pkgs, ... }:

let

  git-prompt = ''
    # Adapted from code found at <https://gist.github.com/1712320>.

    setopt prompt_subst
    autoload -U colors && colors # Enable colors in prompt

    # Modify the colors and symbols in these variables as desired.
    GIT_PROMPT_SYMBOL="%{$fg[blue]%}%{$reset_color%}"
    GIT_PROMPT_PREFIX="("
    GIT_PROMPT_SUFFIX=")"
    GIT_PROMPT_OK="%{$fg[green]%}✔%{$reset_color%}"
    GIT_PROMPT_SEP="%{$reset_color%}|"
    GIT_PROMPT_AHEAD="%{$fg[red]%}↑NUM%{$reset_color%}"
    GIT_PROMPT_BEHIND="%{$fg[cyan]%}↓NUM%{$reset_color%}"
    GIT_PROMPT_MERGING="%{$fg[magenta]%}⚡︎%{$reset_color%}"
    GIT_PROMPT_UNTRACKED="%{$fg[red]%}•%{$reset_color%}"
    GIT_PROMPT_MODIFIED="%{$fg[yellow]%}•%{$reset_color%}"
    GIT_PROMPT_STAGED="%{$fg[green]%}•%{$reset_color%}"

    # Show Git branch/tag, or name-rev if on detached head
    parse_git_branch() {
      (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
    }

    # Show different symbols as appropriate for various Git repository states
    parse_git_state() {

      # Compose this value via multiple conditional appends.
      local GIT_STATE=""

      local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
      if [ "$NUM_AHEAD" -gt 0 ]; then
        GIT_STATE=$GIT_STATE''${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
      fi

      local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
      if [ "$NUM_BEHIND" -gt 0 ]; then
        GIT_STATE=$GIT_STATE''${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
      fi

      local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
      if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
        GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
      fi

      if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
        GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
      fi

      if ! git diff --quiet 2> /dev/null; then
        GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
      fi

      if ! git diff --cached --quiet 2> /dev/null; then
        GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
      fi

      if [[ -n $GIT_STATE ]]; then
        echo "$GIT_PROMPT_SEP$GIT_STATE"
      else
        echo "$GIT_PROMPT_SEP$GIT_PROMPT_OK"
      fi

    }

    # If inside a Git repository, print its branch and state
    git_super_status() {
      local git_where="$(parse_git_branch)"
      [ -z "$HIDE_GIT_PROMPT" ] && \
        [ -n "$git_where" ] && \
         echo "$GIT_PROMPT_SYMBOL$GIT_PROMPT_PREFIX%{$fg[magenta]%}''${git_where#(refs/heads/|tags/)}%{$reset_color%}$(parse_git_state)$GIT_PROMPT_SUFFIX"
    }
  '';

in

''
  # eval "$(stack --bash-completion-script stack)"
  # export WORKON_HOME=$HOME/.virtualenvs
  # source ${pkgs.python37Packages.virtualenvwrapper}/bin/virtualenvwrapper_lazy.sh

  if [ -f $HOME/.local-zshrc ]; then
    source $HOME/.local-zshrc
  fi

  nvminit() {
    unset -f npm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  }

  hs() {
    eval "nix-shell -p 'haskellPackages.ghcWithPackages (pkgs: with pkgs; [ $@ ])'"
  }

  py() {
    eval "nix-shell -p 'python37.withPackages (pkgs: with pkgs; [ ipython $@ ])'"
  }

  ##########
  # prompt #
  ##########

  ${git-prompt}

  build_prompt() {
    local symbols
    symbols=()
    [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{white}%}⚙"
    [[ -n "$symbols" ]] && echo -n "$symbols "
  }

  symb="$"
  # symb="λ"
  # symb="»"

  local ret_status="%(?:%{$fg_bold[green]%}$symb:%{$fg_bold[red]%}$symb)"
  local root_ret_status="%(?:%{$fg_bold[green]%}#:%{$fg_bold[red]%}#)"
  PROMPT='$(build_prompt)%{$fg[green]%}%~%{$reset_color%}$(git_super_status) %(!.''${root_ret_status}.''${ret_status})%{$reset_color%} '
  PROMPT2='%{$fg[green]%}┌─╼ %{$reset_color%}$(build_prompt)%{$fg[green]%}%~%{$reset_color%}$(git_super_status)
  %{$fg[green]%}└╼ %(!.''${root_ret_status}.''${ret_status})%{$reset_color%} '
  RPROMPT='[%T]'

  switch_prompts() {
      local tmp=$PROMPT
      PROMPT=$PROMPT2
      PROMPT2=$tmp
  }

  alias sp=switch_prompts
''
