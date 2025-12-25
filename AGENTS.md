# Bash commands
- `nh os switch`: build and switch to new NixOS generation (including home-manager)
- `nh os build`: build only

# Code style
## Shell Scripts in Nix
Use `pkgs.writeShellApplication`, provide all necessary `runtimeInputs` and move the script into its own file inside the <module>/scripts/ dir.

# Workflow
- Instead of searching the web for NixOS or home-manager options, use `man configuration.nix` for NixOS and `man home-configuration.nix` for the home-manager manual locally.
