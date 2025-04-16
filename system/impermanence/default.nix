# General impermanence setup
# Note: specifics should live with their respective modules, where possible!
{}: {
  environment.persistence."/persistent" = {
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
}
