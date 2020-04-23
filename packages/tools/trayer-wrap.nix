{ pkgs }:

pkgs.writeScriptBin "trayer-wrap" ''
  #!${pkgs.bash}/bin/bash

  ${pkgs.trayer}/bin/trayer \
    --edge top --align right --widthtype percent --width 5 \
    --heighttype pixel --height 25 --SetDockType true \
    --SetPartialStrut true --expand false --transparent true \
    --alpha 0 --tint 0x272727
''
