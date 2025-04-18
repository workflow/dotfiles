# General impermanence setup
# Note: specifics should live with their respective modules, where possible!
{}: {
  fileSystems."/persist/".neededForBoot = true;
  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/var/lib/bluetooth"
      "/var/lib/docker"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/log"
    ];
    files = [
      "/etc/group"
      "/etc/machine-id"
      "/etc/passwd"
      "/etc/shadow"
    ];
  };

  programs.fuse.userAllowOther = true; # Needed for home-manager's impermanence allowOther option to work
}
