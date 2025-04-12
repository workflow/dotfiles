# Setup Instructions

## Create a bootable USB drive

- Download Minimal NixOS to `$ISO_PATH`
- insert drive
- `lsblk` -> find out drive name (e.g. `/dev/sdb`) `$DRIVE`
- run (as root) `dd bs=4M if=$ISO_PATH of=$DRIVE conv=fdatasync status=progress && sync`

## Optional: Installing dual-boot Windows 11 for driver checks etc...

1. Enable secure boot
1. Install Windows 11. Windows 11 now lets you choose size of primary partition during install, I recommend 200GB on a 4TB drive, but lower (100GB) should be fine.
1. Install all updates under Windows while we're at it.
1. Optional: Create a windows recovery USB Drive (Search for "Create Recovery Drive") [Fair warning: This is slooooooooow].
1. Disable secure boot
1. Clear secure boot keys
1. Install NixOS as below, creating a new EFI boot partition separate from the windows one.

## Actual installation using and Impermanence

Fantastic Inspiration: https://www.youtube.com/watch?v=YPKwkWtK7l0
NixOS Guide on using Btrfs: https://nixos.wiki/wiki/Btrfs

Note: [Disko](https://github.com/nix-community/disko) doesn't support dual-booting just yet, so we're still doing it imperatively.

1. Boot into Minimal NixOS
1. `sudo su`
1. `nix-shell -p neovim`
1. `lsblk` -> find out disk name (e.g. `/dev/nvme0n1`) `$DISK`
1. `export DISK=/dev/nvme0n1`
1. `gdisk $DISK`
   1. `p` (print)
   1. `d` (delete)
   1. `n` (new)
      1. number=(1|5), begin=default, end=`+2G`, hex code=`ef00` (`$BOOT` from now on, or `/dev/nvme0n1p5` etc)
      1. number=(2|6), begin=default, end=default, hex code=`8e00` (`$MAIN` from now on)
   1. `w` (write)
1. `export BOOT=/dev/nvme0n1p5`
1. `export MAIN=/dev/nvme0n1p6`
1. LVM on LUKS (BTRFS setup inspired by https://github.com/nix-community/disko/blob/master/example/luks-btrfs-subvolumes.nix)

   1. `cryptsetup luksFormat $MAIN`
   1. `cryptsetup luksOpen $MAIN nixos-enc`
   1. `pvcreate /dev/mapper/nixos-enc`
   1. `vgcreate nixos-vg /dev/mapper/nixos-enc`
   1. `lvcreate --size <swap size, e.g. 8G, usually pick 2xRAM for hibernation if space doesn't matter> --name swap nixos-vg`
   1. `lvcreate --size 100%FREE --name root nixos-vg`

1. Create Boot and Main FS

   1. `mkfs.vfat -n boot $BOOT`
   1. `nix-shell -p btrfs-progs`
   1. `mkfs.btrfs --label nixos /dev/nixos-vg/root`
      1. `mkdir -p /mnt`
      1. `mount /dev/nixos-vg/root /mnt`
      1. `btrfs subvolume create /mnt/root`
      1. `btrfs subvolume create /mnt/nix`
      1. `btrfs subvolume create /mnt/persist`
      1. `btrfs subvolume create /mnt/home`
      1. `umount /mnt`

1. Create and Mount Swap

   1. `mkswap --label swap /dev/nixos-vg/swap`
   1. `swapon /dev/nixos-vg/swap`

1. Mount Everything

   1. `mount -o compress=zstd,noatime,subvol=root /dev/nixos-vg/root /mnt`
   1. `mkdir /mnt/{home,nix,persist}`
   1. `mount -o compress=zstd,noatime,subvol=nix /dev/nixos-vg/root /mnt/nix`
   1. `mount -o compress=zstd,noatime,subvol=persist /dev/nixos-vg/root /mnt/persist`
   1. `mount -o compress=zstd,noatime,subvol=home /dev/nixos-vg/root /mnt/home`
   1. `mkdir /mnt/boot`
   1. `mount $BOOT /mnt/boot`

1. Generate config
   1. `nixos-generate-config --root /mnt`
1. Add Btrfs mount options to hardware-config (since `nixos-generate-config` doesn't do that automatically yet):
   `vim /mnt/etc/nixos/hardware-configuration.nix`
   ```nix
    fileSystems = {
      "/".options = [ "compress=zstd" "noatime" ];
      ...
    };
   ```
1. Add minimum required stuff to config (`vim /mnt/etc/nixos/configuration.nix`)

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

1. Nixos go brrrrrrrrrrrrrrrrrrrrrrrrrrrrrr

   `nixos-install`

1. `reboot`

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
