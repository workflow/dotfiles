# myEnvFun

```nix
myGhcEnvFun = pkgs.myEnvFun {
  name = "my-ghc";
  buildInputs = with pkgs.haskellPackages; [
    (ghcWithPackages (p: with p; [ lens aeson ]))
    djinn
  ];
};
```

then

`load-env-my-ghc`

# split packages (WIP)

```nix
packages_ = {
  nonGraphical = {
    basic = [
      pkgs.binutils-unwrapped pkgs.git pkgs.gnumake pkgs.gnupg pkgs.ispell
      pkgs.tree pkgs.wget pkgs.xclip pkgs.htop pkgs.openvpn pkgs.ag pkgs.bat
      pkgs.exa pkgs.fd pkgs.fzf pkgs.tmux pkgs.vim pkgs.ripgrep
      pkgs.docker-compose pkgs.cachix kbconfig
    ];
    fancy = [
      latex pkgs.powertop pkgs.nixpkgs-fmt pkgs.graphviz pkgs.pandoc pkgs.tldr
      pkgs.python37 pkgs.python37Packages.black pkgs.direnv
      pkgs.nix-prefetch-git emacs-27 niv patat pydf cookie
    ];
  };
  graphical = {
    basic = [
      pkgs.xorg.xmessage pkgs.i3lock-fancy pkgs.rofi pkgs.scrot
    ];
    fancy = [
      pkgs.acpilight pkgs.gnome3.gedit pkgs.gnome3.nautilus pkgs.pavucontrol
      pkgs.playerctl pkgs.redshift pkgs.system-config-printer pkgs.dropbox
      pkgs.evince pkgs.google-chrome pkgs.postman pkgs.spotify pkgs.deluge
      pkgs.vlc pkgs.zoom-us i3lock-wrap xmonad-build
    ];
  };
};
```
