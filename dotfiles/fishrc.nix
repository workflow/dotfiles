{ lib
, pkgs
, profile
}:
let
  functions = {
    fish_user_key_bindings = ''
      # CTRL-F --> original TAB behaviour
      bind \cf forward-word
      # Tab --> accept autosuggestions
      bind \t forward-char
      bind \cs complete
    '';

    fish_right_prompt = ''
      # Capture the exit status of last command, to be displayed in notification
      set exit_status $status

      # Obtain the name of the command which executed last from the history
      set command_name $history[1]

      # Find out the command duration using fish built-in CMD_DURATION
      set command_duration $CMD_DURATION

      # CMD_DURATION will be empty when a new shell starts
      if [ $command_duration ]
          set finish_duration (math "$CMD_DURATION / 1000")
      else
          set finish_duration 0
      end

      # Set the notify duration to 10 secs
      # This can be changed here or script modified to use env variable
      set notify_duration 10

      # If the last command exceeded 10 secs, pop up a notification
      if [ $finish_duration -gt $notify_duration ]
          notify-send --category=shell --icon=go-next "$command_name" "Finished in: $finish_duration secs\nStatus: $exit_status"
      end
    '';

    issue_branch = ''
      set converted (echo $argv[1] | perl -pe 's|[\n\r]+||g' | perl -pe 's|\W+|-|g' | perl -nle 'print lc' | perl -pe 's|(\d+)$|#\1|g') 
            echo (git checkout -b $converted)
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

    py = ''
      eval "nix-shell -p 'python38.withPackages (pkgs: with pkgs; [ ipython $argv ])'"
    '';

    start_tmux = ''
      if type tmux > /dev/null
        #if not inside a tmux session, and if no session is started, start a new session
        if test -z "$TMUX" ; and test -z $TERMINAL_CONTEXT
            tmux -2 attach; or tmux -2 new-session
        end
      end
    '';
  };

  path = lib.concatStringsSep " " profile.path;

  plugins = [
    {
      name = "pure-prompt";
      src = pkgs.fetchFromGitHub {
        owner = "rafaelrinaldi";
        repo = "pure";
        rev = "d66aa7f0fec5555144d29faec34a4e7eff7af32b";
        sha256 = "0klcwlgsn6nr711syshrdqgjy8yd3m9kxakfzv94jvcnayl0h62w";
      };
    }
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

    set PATH ${path} $PATH

    ${variables}
    ${theme}

    #start_tmux
  '';
}
