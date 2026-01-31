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
│   ├── modules.nix              # Imports flake-parts.flakeModules.modules
│   ├── hosts.nix                # Host definitions, dendrix options, and feature composition
│   │
│   ├── _hosts/                  # Host-specific config (underscore excludes from import-tree)
│   │   ├── flexbox/
│   │   │   ├── default.nix      # Host-specific NixOS settings
│   │   │   └── hardware-scan.nix
│   │   └── numenor/
│   │       ├── default.nix
│   │       └── hardware-scan.nix
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
│
└── doc/
    └── DENDRITIC.md
```

## Anatomy of a Feature File

A feature file configures all aspects of a single feature:

```nix
# parts/features/apps/alacritty.nix
{ ... }:
{
  flake.modules.nixos.alacritty = { pkgs, ... }: {
    fonts.packages = [ pkgs.fira-code ];
  };

  flake.modules.homeManager.alacritty = { pkgs, lib, osConfig, ... }: {
    programs.alacritty = {
      enable = true;
      settings = {
        font.normal.family = "FiraCode Nerd Font";
      };
    };

    # Feature owns its persistence paths
    # Use osConfig to access NixOS-level dendrix options from home-manager
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [ ".config/alacritty" ];
    };
  };
}
```

## Host-Specific Values via NixOS Options

Instead of threading `specialArgs` through module evaluations, host-specific values are defined as NixOS options (`config.dendrix.*`). These are defined in `parts/hosts.nix` and set for each host:

```nix
# parts/hosts.nix (excerpt)
{config, lib, inputs, ...}: let
  # NixOS module that defines dendrix options
  dendrixOptionsModule = {lib, ...}: {
    options.dendrix = {
      hostname = lib.mkOption { type = lib.types.str; };
      isLaptop = lib.mkOption { type = lib.types.bool; default = false; };
      isImpermanent = lib.mkOption { type = lib.types.bool; default = false; };
      hasNvidia = lib.mkOption { type = lib.types.bool; default = false; };
      hasAmd = lib.mkOption { type = lib.types.bool; default = false; };
      stateVersion = lib.mkOption { type = lib.types.str; };
      homeStateVersion = lib.mkOption { type = lib.types.str; };
    };
  };

  mkHost = { hostname, hostModule, dendrixConfig, ... }:
    nixpkgs.lib.nixosSystem {
      modules = [
        dendrixOptionsModule
        { dendrix = dendrixConfig; }  # Set values for this host
        # ... other modules
      ];
    };
in {
  flake.nixosConfigurations = {
    flexbox = mkHost {
      hostname = "flexbox";
      hostModule = ./_hosts/flexbox;
      dendrixConfig = {
        hostname = "flexbox";
        isLaptop = true;
        hasNvidia = true;
        # ...
      };
    };
  };
}
```

Feature modules access these values from NixOS config:

```nix
# parts/features/hardware/nvidia.nix - NixOS modules use config.dendrix.*
{ ... }:
{
  flake.modules.nixos.nvidia = { config, lib, ... }: {
    hardware.nvidia.enable = lib.mkIf config.dendrix.hasNvidia true;
  };

  # Home-manager modules use osConfig.dendrix.*
  flake.modules.homeManager.nvidia = { osConfig, lib, ... }: {
    home.sessionVariables = lib.mkIf osConfig.dendrix.hasNvidia {
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
  };
}
```

## Host Definition

Hosts are defined in `parts/hosts.nix` using a `mkHost` helper that composes all dendritic modules:

```nix
{ config, lib, inputs, ... }: let
  # Collect all dendritic modules
  nixosModules = builtins.attrValues config.flake.modules.nixos;
  homeManagerModules = builtins.attrValues config.flake.modules.homeManager;

  mkHost = { hostname, hostModule, dendrixConfig, ... }:
    inputs.nixpkgs.lib.nixosSystem {
      modules =
        commonNixosModules      # External modules (home-manager, stylix, etc.)
        ++ [ dendrixOptionsModule ]
        ++ nixosModules         # All dendritic NixOS modules
        ++ [
          hostModule            # Host-specific hardware and settings
          { dendrix = dendrixConfig; }
          {
            home-manager.sharedModules = homeManagerModules;
          }
        ];
    };
in {
  flake.nixosConfigurations = {
    flexbox = mkHost {
      hostname = "flexbox";
      hostModule = ./_hosts/flexbox;
      dendrixConfig = { hostname = "flexbox"; isLaptop = true; hasNvidia = true; /* ... */ };
    };
    numenor = mkHost {
      hostname = "numenor";
      hostModule = ./_hosts/numenor;
      dendrixConfig = { hostname = "numenor"; isImpermanent = true; hasAmd = true; /* ... */ };
    };
  };
}
```

All dendritic modules are included in all hosts. Features use `config.dendrix.*` to conditionally enable host-specific behavior.

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
