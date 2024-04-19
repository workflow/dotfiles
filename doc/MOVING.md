# Moving to a new disk

1. Prepare the new disk according to the [Partitioning Information](https://github.com/workflow/dotfiles?tab=readme-ov-file#fresh-install) up to the point just before mounting the swap/disks
1. Update the hardware configuration (e.g. `nixos-config/machines/my-machine/hardware-scan.nix` and maybe `nixos-config/machines/my-machine/system.nix`) to point to the new partitions 
1. Mount the new boot partition in-place: `sudo mount $NEWBOOT /boot`
1. Install the new configuration, including bootloader: `sudo nixos-rebuild boot --install-bootloader --flake .#my-machine`
1. Reboot into an installation disk
1. Mount the old root parition at `/mnt/old`
1. Mount the new root parition at `/mnt/new`
1. Copy everything over, preserving creation times with `-N` for syncthing:
```bash
rsync -aAXvN --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} /mnt/old/ /mnt/new
```
1. Reboot into the new drive and enjoy =)


