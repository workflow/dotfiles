# Bash commands
- `nh os switch`: build and switch to new NixOS generation (including home-manager)
- `nh os build`: build only
- `man configuration.nix`: NixOS manual
- `man home-configuration.nix`: Home Manager manual

# Code style
## Shell Scripts in Nix
Use `pkgs.writeShellApplication`, provide all necessary `runtimeInputs` and move the script into its own file inside the <module>/scripts/ dir.

# Workflow
