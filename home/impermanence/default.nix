# General home-manager impermanence setup
# Note: specifics should live with their respective modules, where possible!
{
  home.persistence."/persist" = {
    enable = true;
    directories = [
      ".cache/nix"
      ".config/helm" # Helm repositories
      ".config/nix" # cachix repositories and such
      ".local/share/nix" # Nix Repl History
    ];
  };
}
