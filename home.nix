{ pkgs, ... }:

let

  myLib = import ./lib.nix { pkgs = pkgs; };
  tmpl = myLib.template;
  dotfile = path: import path { pkgs = pkgs; };

in

{
  home.file = {
    # vim
    ".vimrc".text = dotfile ./dotfiles/vimrc.nix;

    # tmux
    ".tmux.conf".text = dotfile ./dotfiles/tmux.nix;

    # git
    ".gitconfig".text = dotfile ./dotfiles/gitconfig.nix;

    # shells
    ".config/fish/config.fish".text = dotfile ./dotfiles/fishrc.nix;
    ".bashrc".text = dotfile ./dotfiles/bashrc.nix;
    ".zshrc".text = dotfile ./dotfiles/zshrc.nix;

    # others
    ".ghci".text = dotfile ./dotfiles/ghci.nix;
  };
}
