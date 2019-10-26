{ pkgs }:

let

  fzf = pkgs.fzf;

in

pkgs.myLib.template ./vimrc {
  fzf = "${fzf}/share/vim-plugins/fzf-${fzf.version}";
}
