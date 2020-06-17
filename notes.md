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

# upgrade to 20.03

- The option `services.xserver.desktopManager.xfce.extraSessionCommands' defined in `/home/alex/nixos-config/system/desktop.nix' has been renamed to `services.xserver.displayManager.sessionCommands'
