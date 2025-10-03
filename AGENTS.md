# Agents.md

Knock yourself out, but please only document architecturally relevant stuff, not small changes.

# Shell Scripts in Nix

Use `pkgs.writeShellApplication`, provide all necessary `runtimeInputs` and move the script into its own file inside the <module>/scripts/ dir.

# Rebuild the system

With `nh os switch`
