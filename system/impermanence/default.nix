# General impermanence setup
# Note: specifics should live with their respective modules, where possible!
{lib, ...}: {
  # Explode / on every boot and resume, see https://grahamc.com/blog/erase-your-darlings/
  #boot.initrd.postResumeCommands = lib.mkAfter ''
  #  # Back up / with timestamp under /old_roots
  #  mkdir /btrfs_tmp
  #  mount /dev/mapper/nixos--vg-root /btrfs_tmp

  #  # root impermanence
  #  if [[ -e /btrfs_tmp/root ]]; then
  #      mkdir -p /btrfs_tmp/persist/old_roots
  #      timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
  #      if [[ ! -e /btrfs_tmp/persist/old_roots/$timestamp ]]; then
  #        mv /btrfs_tmp/root "/btrfs_tmp/persist/old_roots/$timestamp"
  #      else
  #        btrfs subvolume delete /btrfs_tmp/root
  #      fi
  #  fi

  #  # Recursively Garbage Collect: old_roots older than 30 days
  #  delete_subvolume_recursively() {
  #      IFS=$'\n'

  #      # If we accidentally end up with a file or directory under old_roots,
  #      # the code will enumerate all subvolumes under the main volume.
  #      # We don't want to remove everything under true main volume. Only
  #      # proceed if this path is a btrfs subvolume (inode=256).
  #      if [ $(stat -c %i "$1") -ne 256 ]; then return; fi

  #      for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
  #          delete_subvolume_recursively "/btrfs_tmp/$i"
  #      done
  #      btrfs subvolume delete "$1"
  #  }
  #  #for i in $(find /btrfs_tmp/persist/old_roots/ -mindepth 1 -maxdepth 1 -mtime +30); do
  #  #    delete_subvolume_recursively "$i"
  #  #done

  #  btrfs subvolume create /btrfs_tmp/root
  #  umount /btrfs_tmp
  #'';

  boot.tmp.cleanOnBoot = true;

  fileSystems."/persist".neededForBoot = true;

  environment.persistence."/persist/system" = {
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
      # "/var/lib/logrotate.status" # TODO: doesn't play nicely with the service yet
    ];
  };

  # Somehow home-manager impermanence doesn't bootstrap these yet, so:
  system.activationScripts.bootstrapPersistHome.text = ''
    mkdir -p /persist/home/farlion
    chown farlion:users /persist/home/farlion
    chmod 0700 /persist/home/farlion
  '';

  programs.fuse.userAllowOther = true; # Needed for home-manager's impermanence allowOther option to work
}
