{
  isImpermanent,
  lib,
  pkgs,
  ...
}: let
  # Provides the ability to download a file by dropping it into a window
  dlfile = pkgs.writers.writeBashBin "dlfile" ''
    url=$(dragon -t -x)

    if [ -n "$url" ]; then
      printf "File Name: "
      name=""
      while [ -z $name ] || [ -e $name ]
      do
        read -r name
        if [ -e "$name" ]; then
          printf "File already exists, overwrite (y|n): "
          read -r ans

          if [ "$ans" = "y" ]; then
            break
          else
            printf "File Name: "
          fi
        fi
      done

      # Download the file with curl
      [ -n "$name" ] && curl -o "$name" "$url" || exit 1
    else
      exit 1
    fi
  '';
in {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".local/share/lf"
    ];
  };

  home.packages = with pkgs; [
    chafa # Images to terminal pixels, used by pistol
    dlfile # Provides the ability to download a file by dropping it into a window
    pistol # Image previewer
    ripdrag
  ];

  home.file = {
    ".config/pistol/pistol.conf".source = ./pistol/pistol.conf;
  };

  programs.lf = {
    enable = true;

    commands = {
      chmod = ''
        ''${{
            printf "Mode Bits: "
            read ans

            for file in "$fx"
            do
              chmod $ans $file
            done

            lf -remote 'send reload'
          }}
      '';

      dlfile = "%dlfile";
      dragon = "%ripdrag -a $fx";

      mkdir = ''
        ''${{
          printf "Directory Name: "
          read ans
          mkdir $ans
        }}
      '';

      mkfile = ''
        ''${{
          printf "File Name: "
          read ans
          $EDITOR $ans
        }}
      '';

      open = ''
        ''${{
          case $(file --mime-type "$f" -bL) in
            text/*|application/json) $EDITOR "$f";;
            video/*|image/*/application/pdf) xdg-open "$f";;
            *) xdg-open "$f";;
          esac
        }}
      '';

      quit-and-cd = ''
        &{{
          pwd > $LF_CD_FILE
          lf -remote "send $id quit"
        }}
      '';

      sudomkfile = ''
        ''${{
          printf "File Name: "
          read ans
          sudo $EDITOR $ANS
        }}
      '';

      trash = ''
        ''${{
          files=$(printf "$fx" | tr '\n' ';')
          while [ "$files" ]; do
            # extract the substring from start of string up to delimiter.
            # this is the first "element" of the string.
            file=''${files%%;*}

            trash-put "$(basename "$file")"
            # if there's only one element left, set `files` to an empty string.
            # this causes us to exit this `while` loop.
            # else, we delete the first "element" of the string from files, and move onto the next.
            if [ "$files" = "$file" ]; then
              files='''
            else
              files="''${files#*;}"
            fi
          done
          }}
      '';

      unarchive = ''
          ''${{
          case "$f" in
            *.zip) unzip "$f";;
            *.tar.gz) tar -xzvf "$f" ;;
            *.tar.bz2) tar -xjvf "$f" ;;
            *.tar) tar -xvf "$f" ;;
            *) echo "Unsupported format" ;;
          esac
        }}
      '';

      yank-file = ''$printf '%s' "$f" | wl-copy'';
      yank-paths = ''$printf '%s' "$fx" | wl-copy'';
      yank-dirname = ''&printf '%s' "$PWD" | wl-copy'';
      yank-basename = ''&basename -a -- $fx | head -c-1 | wl-copy'';
      yank-basename-without-extension = ''&basename -a -- $fx | sed -E 's/\.[^.]+$//' | head -c-1 | wl-copy'';

      z = ''
        %{{
          result="$(zoxide query --exclude $PWD $@ | sed 's/\\/\\\\/g;s/"/\\"/g')"
          lf -remote "send $id cd \"$result\""
        }}
      '';

      zi = ''
        ''${{
          result="$(zoxide query -i | sed 's/\\/\\\\/g;s/"/\\"/g')"
          lf -remote "send $id cd \"$result\""
        }}
      '';
    };

    keybindings = {
      "." = "set hidden!";
      d = null;
      dd = "trash";
      dl = "dlfile";
      dr = "dragon";
      f = "zi";
      h = "chmod";
      k = "down";
      l = "up";
      ";" = "open";
      j = "updir";
      m = null;
      md = "mkdir";
      mf = "mkfile";
      mr = "sudomkfile";
      Q = "quit-and-cd";
      x = "cut";
    };

    previewer = {
      keybinding = "i";
      source = "${pkgs.pistol}/bin/pistol";
    };

    settings = {
      icons = true;
      # Set IFS to newline to allow commands to work with spaces in filenames
      ifs = "\n";
    };
  };

  home.sessionVariables = {
    LF_ICONS = ''
      tw=:\
      st=:\
      ow=:\
      dt=:\
      di=:\
      fi=:\
      ln=:\
      or=:\
      ex=:\
      *.c=:\
      *.cc=:\
      *.clj=:\
      *.coffee=:\
      *.cpp=:\
      *.css=:\
      *.d=:\
      *.dart=:\
      *.erl=:\
      *.exs=:\
      *.fs=:\
      *.go=:\
      *.h=:\
      *.hh=:\
      *.hpp=:\
      *.hs=:\
      *.html=:\
      *.java=:\
      *.jl=:\
      *.js=:\
      *.json=:\
      *.lua=:\
      *.md=:\
      *.php=:\
      *.pl=:\
      *.pro=:\
      *.py=:\
      *.rb=:\
      *.rs=:\
      *.scala=:\
      *.ts=:\
      *.vim=:\
      *.cmd=:\
      *.ps1=:\
      *.sh=:\
      *.bash=:\
      *.zsh=:\
      *.fish=:\
      *.tar=:\
      *.tgz=:\
      *.arc=:\
      *.arj=:\
      *.taz=:\
      *.lha=:\
      *.lz4=:\
      *.lzh=:\
      *.lzma=:\
      *.tlz=:\
      *.txz=:\
      *.tzo=:\
      *.t7z=:\
      *.zip=:\
      *.z=:\
      *.dz=:\
      *.gz=:\
      *.lrz=:\
      *.lz=:\
      *.lzo=:\
      *.xz=:\
      *.zst=:\
      *.tzst=:\
      *.bz2=:\
      *.bz=:\
      *.tbz=:\
      *.tbz2=:\
      *.tz=:\
      *.deb=:\
      *.rpm=:\
      *.jar=:\
      *.war=:\
      *.ear=:\
      *.sar=:\
      *.rar=:\
      *.alz=:\
      *.ace=:\
      *.zoo=:\
      *.cpio=:\
      *.7z=:\
      *.rz=:\
      *.cab=:\
      *.wim=:\
      *.swm=:\
      *.dwm=:\
      *.esd=:\
      *.jpg=:\
      *.jpeg=:\
      *.mjpg=:\
      *.mjpeg=:\
      *.gif=:\
      *.bmp=:\
      *.pbm=:\
      *.pgm=:\
      *.ppm=:\
      *.tga=:\
      *.xbm=:\
      *.xpm=:\
      *.tif=:\
      *.tiff=:\
      *.png=:\
      *.svg=:\
      *.svgz=:\
      *.mng=:\
      *.pcx=:\
      *.mov=:\
      *.mpg=:\
      *.mpeg=:\
      *.m2v=:\
      *.mkv=:\
      *.webm=:\
      *.ogm=:\
      *.mp4=:\
      *.m4v=:\
      *.mp4v=:\
      *.vob=:\
      *.qt=:\
      *.nuv=:\
      *.wmv=:\
      *.asf=:\
      *.rm=:\
      *.rmvb=:\
      *.flc=:\
      *.avi=:\
      *.fli=:\
      *.flv=:\
      *.gl=:\
      *.dl=:\
      *.xcf=:\
      *.xwd=:\
      *.yuv=:\
      *.cgm=:\
      *.emf=:\
      *.ogv=:\
      *.ogx=:\
      *.aac=:\
      *.au=:\
      *.flac=:\
      *.m4a=:\
      *.mid=:\
      *.midi=:\
      *.mka=:\
      *.mp3=:\
      *.mpc=:\
      *.ogg=:\
      *.ra=:\
      *.wav=:\
      *.oga=:\
      *.opus=:\
      *.spx=:\
      *.xspf=:\
      *.pdf=:\
      *.nix=:
    '';
  };
}
