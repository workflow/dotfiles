# General home-manager impermanence setup
# Note: specifics should live with their respective modules, where possible!
{
  home.persistence."/persist/home/farlion" = {
    directories = [
      # TODO: Move most to syncthing module
      "Active Audiobooks"
      "Books"
      "Calibre Library"
      "code"
      "Desktop"
      "Documents"
      "Downloads"
      "nixos-config"
      "nixos-secrets"
      "Music"
      "Pictures"
      "Videos"
      ".backup"
      ".gnupg"
      ".ssh"
    ];
    allowOther = true; # For root (docker) and Docker to access bind-mounted `directories`
  };
}
