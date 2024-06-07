# NixOS Upgrade Checklist

1. Build config with `sudo nixos-rebuild build --flake .#` (don't use `nh` for this one)
2. Test on next boot: `nh os boot`
3. Reboot
4. After everything is more or less working, check for any new hardware settings in  `nixos-generate-config --show-hardware-config`
