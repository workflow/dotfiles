# General impermanence setup
# Note: specifics should live with their respective modules, where possible!
{}: {
  boot.tmp.cleanOnBoot = true;

  fileSystems."/persist/".neededForBoot = true;

  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/nixos/secrets"
      "/var/log"
    ];
    files = [
      "/etc/group"
      "/etc/machine-id"
      "/etc/passwd"
      "/etc/shadow"
      "/etc/gshadow"
    ];
  };

  programs.fuse.userAllowOther = true; # Needed for home-manager's impermanence allowOther option to work
}
