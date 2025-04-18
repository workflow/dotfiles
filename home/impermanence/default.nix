# General home-manager impermanence setup
# Note: specifics should live with their respective modules, where possible!
{
  home.persistence."/persist/home/farlion" = {
    directories = [
      "Downloads"
      "Music"
      "Pictures"
      "Documents"
      "Videos"
      ".backup"
      ".gnupg"
      ".ssh"
      ".local/share/keyrings"
      ".local/share/direnv"
    ];
    allowOther = true; # For root (docker) and Docker to access bind-mounted `directories`
  };
}
