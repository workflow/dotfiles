# General impermanence setup
# Note: specifics should live with their respective modules, where possible!
{lib, ...}: {
  # Explode / on every boot, see https://grahamc.com/blog/erase-your-darlings/
  boot.initrd.postResumeCommands = lib.mkAfter ''
    # Back up / with timestamp under /old_roots
    mkdir /btrfs_tmp
    mount /dev/nixos_vg/root /btrfs_tmp
    if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    # 🧨
    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
    }

    # Garbage Collect: old_roots older than 30 days
    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';

  boot.tmp.cleanOnBoot = true;

  fileSystems."/persist".neededForBoot = true;

  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/systemd/timers" # Persistent Timers
      "/var/lib/udisks2"
      "/etc/nixos/secrets"
      "/var/log"
    ];
    files = [
      "/etc/machine-id"
      "/var/lib/logrotate.status"
    ];
  };

  programs.fuse.userAllowOther = true; # Needed for home-manager's impermanence allowOther option to work
}
