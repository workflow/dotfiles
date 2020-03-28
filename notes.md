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

# kmonad

```
diff --git a/packages/default.nix b/packages/default.nix
index 3410fc8..914804a 100644
--- a/packages/default.nix
+++ b/packages/default.nix
@@ -12,6 +12,7 @@ let
   nixfmt = pkgs.callPackage ./tools/nixfmt.nix {};
   patat = pkgs.callPackage ./tools/patat.nix {};
   pydf = pkgs.callPackage ./tools/pydf.nix {};
+  kmonad = pkgs.callPackage ./tools/kmonad {};

   cookie = pkgs.callPackage ./scripts/cookie.nix {};
   kbconfig = pkgs.callPackage ./scripts/kbconfig.nix {};
@@ -95,6 +96,7 @@ let
       niv
       patat
       pydf
+      kmonad

       cookie
       i3lock-wrap
diff --git a/system/default.nix b/system/default.nix
index 64969bf..0699971 100644
--- a/system/default.nix
+++ b/system/default.nix
@@ -30,11 +30,14 @@ in

   users = {
     users.alex = {
-      extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "docker" ];
+      extraGroups = [ "wheel" "input" "uinput" "video" "audio" "disk" "networkmanager" "docker" ];
       isNormalUser = true;
       shell = pkgs.fish;
     };
     defaultUserShell = pkgs.bash;
+    groups = {
+      uinput = {};
+    };
   };

   time.timeZone = "Europe/London";
@@ -51,6 +54,11 @@ in
   ];

   boot.supportedFilesystems = [ "ntfs" ];
+  boot.kernelModules = [ "uinput" ];
+
+  services.udev.extraRules = ''
+    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
+  '';

   networking.networkmanager.enable = true;
   networking.hostName = "nixos"; # Define your hostname.
```

