# Dendritic Pattern Architecture

This document describes the architecture of this NixOS configuration, which follows the [dendritic pattern](https://github.com/mightyiam/dendritic).

## Core Principles

1. **Aspect-oriented**: Each file configures a single feature across all relevant configuration classes (NixOS, home-manager)
2. **Top-level modules**: All files are flake-parts modules imported into a unified evaluation
3. **Co-location**: Related NixOS and home-manager config live together in one file
4. **Automatic imports**: Files in `parts/` are auto-imported; adding a feature = creating a file
5. **No specialArgs pass-thru**: Host-specific values live in top-level config options, accessible to all modules

## Directory Structure

```
nixos-config/
├── flake.nix                    # Minimal: inputs + import-tree ./parts
├── flake.lock
│
├── parts/                       # All flake-parts modules (auto-imported)
│   ├── options.nix              # config.dendrix.* option definitions
│   ├── modules.nix              # Imports flake-parts.flakeModules.modules
│   ├── hosts.nix                # Host definitions and feature composition
│   │
│   ├── features/                # Feature modules
│   │   ├── core/                # Essential system features
│   │   │   ├── boot.nix
│   │   │   ├── networking.nix
│   │   │   ├── users.nix
│   │   │   ├── nix-settings.nix
│   │   │   └── locale.nix
│   │   │
│   │   ├── hardware/            # Hardware-specific features
│   │   │   ├── nvidia.nix       # Driver + env vars + home config
│   │   │   ├── amd.nix
│   │   │   ├── audio.nix        # PipeWire + home audio tools
│   │   │   └── bluetooth.nix
│   │   │
│   │   ├── desktop/             # Desktop environment
│   │   │   ├── niri.nix         # Compositor + keybindings + scripts
│   │   │   ├── waybar.nix
│   │   │   ├── dunst.nix
│   │   │   ├── fuzzel.nix
│   │   │   └── theming.nix      # Stylix + specialisations
│   │   │
│   │   ├── dev/                 # Development tools
│   │   │   ├── neovim/          # Complex features can be directories
│   │   │   │   ├── default.nix
│   │   │   │   ├── lsp.nix
│   │   │   │   └── plugins/
│   │   │   ├── git.nix
│   │   │   ├── jujutsu.nix
│   │   │   └── claude-code.nix
│   │   │
│   │   ├── apps/                # Applications
│   │   │   ├── firefox.nix
│   │   │   ├── alacritty.nix
│   │   │   ├── fish.nix
│   │   │   └── ...
│   │   │
│   │   ├── services/            # System services
│   │   │   ├── docker.nix
│   │   │   ├── syncthing.nix
│   │   │   └── restic.nix
│   │   │
│   │   └── security/            # Security features
│   │       ├── sops.nix
│   │       ├── gpg.nix
│   │       └── keyring.nix
│   │
│   └── hosts/                   # Host-specific config
│       ├── flexbox/
│       │   ├── default.nix      # Host options + overrides
│       │   └── hardware-scan.nix
│       └── numenor/
│           ├── default.nix
│           └── hardware-scan.nix
│
└── doc/
    └── DENDRITIC.md
```

## Anatomy of a Feature File

A feature file configures all aspects of a single feature:

```nix
# parts/features/apps/alacritty.nix
{ config, lib, ... }:
{
  flake.modules.nixos.alacritty = { pkgs, ... }: {
    fonts.packages = [ pkgs.fira-code ];
  };

  flake.modules.homeManager.alacritty = { pkgs, ... }: {
    programs.alacritty = {
      enable = true;
      settings = {
        font.normal.family = "FiraCode Nerd Font";
      };
    };

    # Feature owns its persistence paths
    home.persistence."/persist" = lib.mkIf config.dendrix.isImpermanent {
      directories = [ ".config/alacritty" ];
    };
  };
}
```

## Host-Specific Values via Top-Level Config

Instead of threading `specialArgs` through module evaluations, host-specific values are defined as options in the top-level configuration. Every module can read from this shared config:

```nix
# parts/options.nix
{ lib, ... }:
{
  options.dendrix = {
    hostname = lib.mkOption { type = lib.types.str; };
    isLaptop = lib.mkOption { type = lib.types.bool; default = false; };
    isImpermanent = lib.mkOption { type = lib.types.bool; default = false; };
    hasNvidia = lib.mkOption { type = lib.types.bool; default = false; };
    hasAmd = lib.mkOption { type = lib.types.bool; default = false; };
  };
}

# parts/hosts/flexbox/default.nix
{ ... }:
{
  config.dendrix = {
    hostname = "flexbox";
    isLaptop = true;
    hasNvidia = true;
  };
}

# Any feature can then access these values:
# parts/features/hardware/nvidia.nix
{ config, lib, ... }:
{
  flake.modules.nixos.nvidia = lib.mkIf config.dendrix.hasNvidia {
    # NVIDIA configuration
  };
}
```

## Host Definition

Hosts compose features in `parts/hosts.nix`:

```nix
{ inputs, ... }:
{
  flake.nixosConfigurations = {
    flexbox = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        inputs.self.modules.nixos.boot
        inputs.self.modules.nixos.networking
        inputs.self.modules.nixos.users
        inputs.self.modules.nixos.nvidia
        inputs.self.modules.nixos.niri
        inputs.self.modules.nixos.theming
        inputs.self.modules.nixos.alacritty

        ../hosts/flexbox/hardware-scan.nix
        inputs.self.modules.nixos.host-flexbox
      ];
    };

    numenor = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        inputs.self.modules.nixos.amd
        inputs.self.modules.nixos.impermanence
        # ...
      ];
    };
  };
}
```

## Key Concepts

### flake-parts

[flake-parts](https://flake.parts) provides the module system for flake outputs. The `flake.modules.<class>.<name>` options use `deferredModule` types, allowing modules to be defined once and composed into multiple host configurations.

### Feature Ownership

Each feature owns all its concerns:
- System-level configuration (`flake.modules.nixos.*`)
- User-level configuration (`flake.modules.homeManager.*`)
- Persistence paths (declared within the home-manager module)
- Scripts (co-located in the feature file or a sibling `scripts/` directory)

### Specialisations

Theme switching is handled in `parts/features/desktop/theming.nix`:

```nix
flake.modules.nixos.theming = { ... }: {
  stylix.base16Scheme = "gruvbox-dark-hard.yaml";

  specialisation.light.configuration = {
    stylix.base16Scheme = "catppuccin-latte.yaml";
    stylix.polarity = "light";
  };
};
```

## References

- [Dendritic pattern introduction (video)](https://youtu.be/-TRbzkw6Hjs)
- [mightyiam/dendritic](https://github.com/mightyiam/dendritic)
- [flake.parts documentation](https://flake.parts)
- [Doc-Steve/dendritic-design-with-flake-parts](https://github.com/Doc-Steve/dendritic-design-with-flake-parts)
