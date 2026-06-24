# NixOS Upgrade Checklist

1. Start writing a new adventure
2. Go through release manual
4. Build config with `sudo nixos-rebuild build --flake .#` (don't use `nh` for this one)
5. Test on next boot: `nh os boot`
6. Reboot
7. After everything is more or less working, check for new hardware settings: `sudo nixos-generate-config --show-hardware-config` (needs root for btrfs subvolume info). Ignore the hundreds of `/nix/persist/...` bind mounts (impermanence noise); only compare the real hardware bits — kernel modules, `extraModulePackages`, cpu/microcode — against the host's `hardware-scan.nix`. Fewer detected modules is fine to keep; only act on *new* ones.
8. Re-evaluate `unstable` and other overrides
1. Go through `home-manager` news: `home-manager news` or https://github.com/nix-community/home-manager/blob/master/modules/misc/news.nix
