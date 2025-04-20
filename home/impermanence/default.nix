# General home-manager impermanence setup
# Note: specifics should live with their respective modules, where possible!
{
  home.persistence."/persist/home/farlion" = {
    files = [
      ".config/helm" # Helm repositories
      ".config/nix" # cachix repositories and such
      ".local/share/flatpak"
      "nixos-config"
      "nixos-secrets"
    ];
    allowOther = true; # For root (docker) and Docker to access bind-mounted `directories`
  };
}
