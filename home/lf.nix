{ pkgs, ... }:
let
  nixpkgs-unstable = pkgs.unstable;

in
{
  programs.lf = {
    enable = true;

    commands = {
      broot_jump = ''
        ''${{
          f=$(mktemp)
          res="$(broot --outcmd $f && cat $f | sed 's/cd //')"
          rm -f "$f"
          if [ -f "$res" ]; then
            cmd="select"
          elif [ -d "$res" ]; then
            cmd="cd"
          fi
          lf -remote "send $id $cmd \"$res\""
        }}
      '';

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
      f = "broot_jump";
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
      u = "unarchive";
      x = "cut";
    };

    previewer = {
      keybinding = "i";
      source = "${nixpkgs-unstable.pistol}/bin/pistol";
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
