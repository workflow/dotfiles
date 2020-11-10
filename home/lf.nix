{ pkgs, ... }:
{
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

      sudomkfile = ''
        ''${{
          printf "File Name: "
          read ans
          sudo $EDITOR $ANS
        }}
      '';

      trash = ''
        %trash-put $fx
      '';

      unarchive = ''
        ''${{
          case "$f" in
              *.zip) unzip "$f" ;;
              *.tar.gz) tar -xzvf "$f" ;;
              *.tar.bz2) tar -xjvf "$f" ;;
              *.tar) tar -xvf "$f" ;;
              *) echo "Unsupported format" ;;
          esac
        }}
      '';
    };

    keybindings = {
      d = null;
      dd = "trash";
      h = "chmod";
      k = "down";
      l = "up";
      ";" = "open";
      j = "updir";
      m = null;
      md = "mkdir";
      mf = "mkfile";
      mr = "sudomkfile";
      u = "unarchive";
    };

    settings = {
      color256 = true;
      hidden = true;
    };
  };
}
