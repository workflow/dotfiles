{
  config,
  isImpermanent,
  lib,
  pkgs,
  ...
}: let
  functions = {
    fish_user_key_bindings =
      /*
      fish
      */
      ''
        fish_vi_key_bindings

        # VI mode updates
        bind -s --preset --mode default j backward-char
        bind -s --preset --mode default \; forward-char
        bind -s --preset k down-or-search
        bind -s --preset l up-or-search
        bind -s --preset --mode visual j backward-char
        bind -s --preset --mode visual \; forward-char
        bind -s --preset --mode visual l up-line
        bind -s --preset --mode visual k down-line

        # Completions
        bind -s --mode insert \cw forward-word
        # Tab --> accept autosuggestions
        bind -s --mode insert \t accept-autosuggestion
        # CTRL-S --> original TAB behaviour
        bind -s --mode insert \cs complete

        # Bang-Bang bindings, manually added so they have precedence:
        bind --mode insert ! __history_previous_command
        bind --mode insert '$' __history_previous_command_arguments
      '';

    ## Wrap LF to add ability to quit with Q in current directory
    ##
    ## Adapted for fish from https://github.com/gokcehan/lf/wiki/Tips#cd-to-current-directory-on-quit
    ##
    lf =
      /*
      fish
      */
      ''
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

    pirate =
      /*
      fish
      */
      ''
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
    posix-source =
      /*
      fish
      */
      ''
        for i in (cat $argv)
              set arr (echo $i | string match -r "([^=]+)=(.*)")
            set -gx $arr[2] $arr[3]
        end
      '';

    kubectlgetall =
      /*
      fish
      */
      ''
        for i in (kubectl api-resources --verbs=list --namespaced -o name | grep -v "events.events.k8s.io" | grep -v "events" | sort | uniq)
          echo "Resource:" $i
          kubectl -n "$argv[1]" get --ignore-not-found "$i"
        end
      '';
  };

  plugins = with pkgs.fishPlugins; [
    {
      name = "bang-bang";
      src = bang-bang.src;
    }
  ];

  shellInit = ''
    thefuck --alias | source

    ${variables}
  '';

  variables =
    /*
    fish
    */
    ''
      set -g fish_key_bindings fish_default_key_bindings
      set fish_greeting  # disable greeting
    '';
in {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".config/fish"
      ".local/share/fish" # contains some unecessary state, but https://github.com/fish-shell/fish-shell/issues/10730 prevents us from only syncing the history file (.local/share/fish/fish_history)
    ];
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = shellInit;
    inherit functions plugins;
    shellAbbrs = config.home.shellAliases;
  };
}
