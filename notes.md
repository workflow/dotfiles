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

# boot menu doesn't appear

```
sudo -i
cat /sys/firmware/efi/efivars/LoaderConfigTimeout-....  # is it 0?
chattr -i /sys/firmware/efi/efivars/LoaderConfigTimeout-....
nix-shell -p efibootmgr
efibootmgr -t 5
```
# kmonad

```
users = {
  users.alex = {
    extraGroups = [ "wheel" "input" "uinput" "video" "audio" "disk" "networkmanager" "docker" ];
  };
  groups = {
    uinput = {};
  };
};

services.udev.extraRules = ''
  KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"

---

{ pkgs }:

let

  version = "0.3.0";
  kmonad = builtins.fetchurl {
    url = "https://github.com/david-janssen/kmonad/releases/download/${version}/kmonad-${version}-linux";
    sha256 = "02zwp841g5slvqvwha5q1ynww34ayfk1cfb1y32f1zzw7n1b0ia5";
  };

in

  pkgs.stdenvNoCC.mkDerivation {
    name = "kmonad-${version}";
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cp ${kmonad} $out/bin/kmonad
      chmod +x $out/bin/kmonad
    '';
  }

---

// IO
INPUT  = LINUX_DEVICE L64 /dev/input/event0
OUTPUT = UINPUT_SINK

@xcp = TN esc lctl
// @xcp = TH 300 esc lctl

// Source codes
SRC
  esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
  grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc ins home pgup
  tab  q    w    e    r    t    y    u    i    o    p    [    ]    \    del end  pgdn
  caps a    s    d    f    g    h    j    k    l    ;    '    ret
  lsft z    x    c    v    b    n    m    ,    .    /    rsft
  lctl lmet lalt           spc                 ralt prnt rctl up
                                                         left down rght

LAYER base
  esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
  grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc ins home pgup
  tab  q    w    e    r    t    y    u    i    o    p    [    ]    \    del end  pgdn
  @xcp a    s    d    f    g    h    j    k    l    ;    '    ret
  lsft z    x    c    v    b    n    m    ,    .    /    rsft
  lctl lmet lalt           spc                 ralt prnt rctl up
                                                         left down rght


```
