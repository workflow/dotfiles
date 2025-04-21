# General home-manager impermanence setup
# Note: specifics should live with their respective modules, where possible!
{
  home.persistence."/persist/home/farlion" = {
    enable = true;
    files = [
      ".config/helm" # Helm repositories
      ".config/nix" # cachix repositories and such
      ".local/share/nix" # Nix Repl History
      "nixos-config"
      "nixos-secrets"
    ];
    allowOther = true; # For root (docker) and Docker to access bind-mounted `directories`
  };
}
