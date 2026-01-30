# Architecture

This configuration follows the [dendritic pattern](doc/DENDRITIC.md). Key points:

- All modules live in `parts/`
- Each feature file configures both NixOS and home-manager aspects together
- Host-specific values are in top-level config options (`config.dendrix.*`), not `specialArgs`
- Features own their persistence paths

# Bash commands

- `nh os switch`: build and switch to new NixOS generation (including home-manager)
- `nh os build`: build only

# Code style

## Shell Scripts in Nix

Use `pkgs.writeShellApplication`, provide all necessary `runtimeInputs` and move the script into its own file inside the `<feature>/scripts/` dir.

# Workflow

- Instead of searching the web for NixOS or home-manager options, use `man configuration.nix` for NixOS and `man home-configuration.nix` for the home-manager manual locally.
