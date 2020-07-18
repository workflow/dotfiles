[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

![neofetch nixbox](assets/neofetch-nixbox.png)

# NixOS configuration

Structure, ideas and some jokes looted from https://github.com/alexpeits/nixos-config. Thank you! 

## Installation instructions

(`$CONFIG` is the location of this repo)

- `git clone git@github.com:workflow/nixos-config.git $CONFIG`
- add `$CONFIG/configuration.nix` to the imports in `/etc/nixos/configuration.nix` (sample configuration is in `assets`)
- add `$CONFIG/nixos-config/hardware-configuration.nix` to the same list
- `sudo nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware`
- `sudo nix-channel --update`
- change your name to `farlion` because it's hardcoded in the configurations
- `sudo mkdir -m 0755 -p /nix/var/nix/{profiles,gcroots}/per-user/farlion` (for `home-manager`)
- `sudo nixos-rebuild switch`
