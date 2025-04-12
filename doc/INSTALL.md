# Setup Instructions

## Create a bootable USB drive

- Download NixOS to `$ISO_PATH`
- insert drive
- `lsblk` -> find out drive name (e.g. `/dev/sdb`) `$DRIVE`
- run (as sudo) `dd bs=4M if=$ISO_PATH of=$DRIVE conv=fdatasync status=progress && sync`

## Optional: Installing dual-boot Windows 11 for driver checks etc...

1. Enable secure boot
1. Install Windows 11. Windows 11 now lets you choose size of primary partition during install, I recommend 200GB on a 4TB drive, but lower (100GB) should be fine.
1. Install all updates under Windows while we're at it.
1. Optional: Create a windows recovery USB Drive (Search for "Create Recovery Drive") [Fair warning: This is slooooooooow].
1. Disable secure boot
1. Clear secure boot keys
1. Install NixOS as below, creating a new EFI boot partition separate from the windows one.

### Actual installation

Roughly this https://qfpl.io/posts/installing-nixos/

- sudo -i
- lsblk -> find out disk name (e.g. `/dev/sda`) `$DISK`
- `export DISK=/dev/sda`
- `gdisk $DISK`
  - `p` (print)
  - `d` (delete)
  - `n` (new)
    - number=1, begin=default, end=`+2G`, hex code=`ef00` (not needed if dual boot) (`$BOOT` from now on, or `/dev/sda1` etc)
    - number=2, begin=default, end=default, hex code=`8e00` (`$MAIN` from now on)
  - `w` (write)
- `export BOOT=/dev/sda1`
- `export MAIN=/dev/sda2`
- encryption
  - `cryptsetup luksFormat $MAIN`
  - `cryptsetup luksOpen $MAIN nixos-enc`
  - `pvcreate /dev/mapper/nixos-enc`
  - `vgcreate nixos-vg /dev/mapper/nixos-enc`
  - `lvcreate -L <swap size, e.g. 8G, usually pick 2xRAM for hibernation if space doesn't matter> -n swap nixos-vg`
  - `lvcreate -l 100%FREE -n root nixos-vg`
- create fs
  - `mkfs.vfat -n boot $BOOT` (not needed if dual boot)
  - `mkfs.ext4 -L nixos /dev/nixos-vg/root`
  - `mkswap -L swap /dev/nixos-vg/swap`
  - `swapon /dev/nixos-vg/swap`
- mount
  - `mount /dev/nixos-vg/root /mnt`
  - `mkdir /mnt/boot`
  - `mount $BOOT /mnt/boot`
- generate config
  - `nixos-generate-config --root /mnt`
- add stuff to config

required:

```nix
boot.initrd.luks.devices = {
  root = {
    device = "$MAIN";
    preLVM = true;
  };
};

# If not dual-booting with GRUB
boot.loader.systemd-boot.enable = true;

networking.networkmanager.enable = true;

users.users.farlion = {
  extraGroups = ["wheel" "video" "audio" "disk" "networkmanager"];
  isNormalUser = true;
};
```

- nixos go brrrr
  - `nixos-install`
  - `reboot`

### Enable this setup

(`$NIXOS_CONFIG` is the location of this repo)

1. change your name to `farlion` because it's hardcoded in the configurations
1. `passwd farlion` and then `su`
1. `git clone https://github.com/workflow/nixos-config.git $NIXOS_CONFIG`
1. From`$NIXOS_CONFIG/machines/*/system.nix` as a template, set required settings like the `networking.hostname` and the correct networking interfaces to enable DHCP
1. Update flake.nix with new machine (name = hostname)
1. `nix shell nixpkgs#cachix -c cachix use workflow-nixos-config`
1. `sudo nixos-rebuild switch --flake $NIXOS_CONFIG#<machine name, empty if hostname> --override-input secrets nixpkgs`
1. Reboot

### Post-installation steps

1. Push any local `$NIXOS_CONFIG` config changes to github
1. Remove local `$NIXOS_CONFIG` and symlink it to `~/code/nixos-config`
1. Go through secret setup instructions / customize system to your needs
1. Change `root` passwd
1. Rerun `nh os switch`
1. Reboot
