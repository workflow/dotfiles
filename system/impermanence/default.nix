# General impermanence setup
# Note: specifics should live with their respective modules, where possible!
{
  lib,
  pkgs,
  ...
}: let
  rootExplosion = ''
    echo "Time to 🧨" >/dev/kmsg
    mkdir /btrfs_tmp
    mount /dev/mapper/nixos--vg-root /btrfs_tmp

    # Root impermanence
    if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/persist/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%d_%H:%M:%S")
        if [[ ! -e /btrfs_tmp/persist/old_roots/$timestamp ]]; then
          mv /btrfs_tmp/root "/btrfs_tmp/persist/old_roots/$timestamp"
        else
          btrfs subvolume delete /btrfs_tmp/root
        fi
    fi

    ###
    # GC
    ###
    latest_snapshot=$(find /btrfs_tmp/persist/old_roots/ -mindepth 1 -maxdepth 1 -type d | sort -r | head -n 1)
    # Only delete old snapshots if there's at least one that will remain after deletion
    if [ -n "$latest_snapshot" ]; then
        for i in $(find /btrfs_tmp/persist/old_roots/ -mindepth 1 -maxdepth 1 -mtime +30 | grep -v -e "$latest_snapshot"); do
            btrfs subvolume delete -R "$i"
        done
    fi

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
    echo "Done with 🧨. Au revoir!" >/dev/kmsg
  '';
in {
  # Explode / on every boot and resume, see https://grahamc.com/blog/erase-your-darlings/
  boot.initrd.systemd = {
    extraBin = {
      grep = "${pkgs.gnugrep}/bin/grep";
    };
    services = {
      root-explode = {
        enableStrictShellChecks = false;
        wantedBy = ["initrd-root-device.target"];
        wants = ["lvm2-activation.service"];
        # See https://github.com/nix-community/impermanence/issues/250#issuecomment-2603848867
        after = ["lvm2-activation.service" "local-fs-pre.target"];
        before = ["sysroot.mount"];
        # Run on cold boot only, never on resume from hibernation
        unitConfig = {
          ConditionKernelCommandLine = ["!resume="];
          RequiresMountsFor = ["/dev/mapper/nixos--vg-root"];
        };
        serviceConfig = {
          StandardOutput = "journal+console";
          StandardError = "journal+console";
          Type = "oneshot";
        };
        script = rootExplosion;
      };
    };
  };

  boot.tmp.cleanOnBoot = true;

  fileSystems."/persist".neededForBoot = true;

  environment.persistence."/persist/system" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/var/lib/logrotate" # See https://github.com/nix-community/impermanence/issues/270
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/systemd/timers"
      "/var/lib/udisks2"
      "/var/log"
    ];
    files = [
      "/etc/machine-id"
    ];
  };
  # Workaround for /etc/ file timings not working with impermanence
  environment.etc = {
    # Timezone data linked by tzupdate
    "localtime".source = "/persist/system/etc/localtime";
  };

  # Woraround for logrotate, see https://github.com/nix-community/impermanence/issues/270
  services.logrotate.extraArgs = lib.mkAfter ["--state" "/var/lib/logrotate/logrotate.status"];

  # home-manager's impermanence module doesn't have permissions to bootstrap these dirs, so we do it here:
  system.activationScripts.bootstrapPersistHome.text = ''
    mkdir -p /persist/home/farlion
    chown farlion:users /persist/home/farlion
    chmod 0700 /persist/home/farlion
  '';

  programs.fuse.userAllowOther = true; # Needed for home-manager's impermanence allowOther option to work
}
