# NixOS Upgrade Checklist

1. Start writing a new adventure
2. Go through release manual
3. Go through `home-manager` news: https://github.com/nix-community/home-manager/blob/master/modules/misc/news.nix
4. Build config with `sudo nixos-rebuild build --flake .#` (don't use `nh` for this one)
5. Test on next boot: `nh os boot`
6. Reboot
7. After everything is more or less working, check for any new hardware settings in `nixos-generate-config --show-hardware-config`
8. Re-evaluate `unstable` and other overrides
