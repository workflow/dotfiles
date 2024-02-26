{ lib
, pkgs
, profile
, ...
}:
let
  functions = {
    fish_user_key_bindings = ''
      fish_vi_key_bindings

      # VI mode updates
      bind -s --preset -M default j backward-char
      bind -s --preset -M default \; forward-char
      bind -s --preset k down-or-search
      bind -s --preset l up-or-search
      bind -s --preset -M visual j backward-char
      bind -s --preset -M visual \; forward-char
      bind -s --preset -M visual l up-line
      bind -s --preset -M visual k down-line

      # Completions
      bind -s -M insert \cw forward-word
      # Tab --> accept autosuggestions
      bind -s -M insert \t accept-autosuggestion
      # CTRL-S --> original TAB behaviour
      bind -s -M insert \cs complete
    '';

    ## Wrap LF to add ability to quit with Q in current directory
    ##
    ## Adapted for fish from https://github.com/gokcehan/lf/wiki/Tips#cd-to-current-directory-on-quit
    ##
    lf = ''
      set -x LF_CD_FILE /var/tmp/.lfcd-$fish_pid
      command lf $argv
      if test -s "$LF_CD_FILE"
          set DIR (realpath (cat "$LF_CD_FILE"))
          if test "$DIR" != "$PWD"
              cd "$DIR"
          end
          rm "$LF_CD_FILE"
      end
      set -e LF_CD_FILE
    '';

    pirate = ''
      set toTranslate $argv
      curl -sG \
        --data-urlencode "english=$toTranslate" \
        'http://pirate.monkeyness.com/cgi-bin/translator.pl?client=monkeyness&version=1.0' -H 'Accept: application/json' -H 'Connection: keep-alive' -H 'Accept-Encoding: gzip, deflate' -H 'Referer: http://pirate.monkeyness.com/online_pirate_translator' -H 'Accept-Language: en-US,en;q=0.9' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.87 Safari/537.36' --compressed --insecure \
      | xq -r .pirateAPI.pirate \
      | curl -sG \
      --data-urlencode "source_text=$toTranslate" \
      'https://speakpirate.com/' -H 'authority: speakpirate.com' -H 'cache-control: max-age=0' -H 'origin: https://speakpirate.com' -H 'upgrade-insecure-requests: 1' -H 'content-type: application/x-www-form-urlencoded' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.87 Safari/537.36' -H 'sec-fetch-mode: navigate' -H 'sec-fetch-user: ?1' -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3' -H 'sec-fetch-site: same-origin' -H 'referer: https://speakpirate.com/' -H 'accept-encoding: gzip, deflate, br' -H 'accept-language: en-US,en;q=0.9' -H 'cookie: __utma=133499724.1448464120.1565964854.1565964854.1565964854.1; __utmc=133499724; __utmz=133499724.1565964854.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __utmt=1; __utmb=133499724.1.10.1565964854' --compressed \
      | pup 'textarea#translated json{}' | jq -r '.[0].text'
    '';

    # Source .env files
    # Source: http://lewandowski.io/2016/10/fish-env/
    posix-source = ''
      for i in (cat $argv)
            set arr (echo $i | string match -r "([^=]+)=(.*)")
          set -gx $arr[2] $arr[3]
      end
    '';

    py = ''
      eval "nix-shell -p 'python38.withPackages (pkgs: with pkgs; [ ipython $argv ])'"
    '';

    kubectlgetall = ''
      for i in (kubectl api-resources --verbs=list --namespaced -o name | grep -v "events.events.k8s.io" | grep -v "events" | sort | uniq)
        echo "Resource:" $i
        kubectl -n "$argv[1]" get --ignore-not-found "$i"
      end
    '';
  };

  path = lib.concatStringsSep " " profile.path;

  plugins = [
    {
      name = "bang-bang";
      src = pkgs.fetchFromGitHub {
        owner = "oh-my-fish";
        repo = "plugin-bang-bang";
        rev = "d45ae216969fa5c3eac0b6248119e8a1da56fe89";
        sha256 = "0jpcs8fpw9a69ai6mwhgikw77j03fhnixcl21yx1b5p65333pddc";
      };
    }
  ];

  shellInit = ''
    if test -e $HOME/.local-fishrc
      source $HOME/.local-fishrc
    end

    set PATH ${path} $PATH
    thefuck --alias | source

    ${variables}
    ${theme}
  '';

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
  programs.fish = {
    enable = true;
    interactiveShellInit = shellInit;
    inherit functions plugins;
    shellAbbrs = profile.aliases;
  };
}
