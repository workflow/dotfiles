{...}: {
  flake.modules.nixos.impermanence = {
    config,
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
  in
    lib.mkIf config.dendrix.isImpermanent {
    boot.initrd.systemd = {
      extraBin = {
        grep = "${pkgs.gnugrep}/bin/grep";
      };
      services = {
        root-explode = {
          enableStrictShellChecks = false;
          wantedBy = ["initrd-root-device.target"];
          wants = ["lvm2-activation.service"];
          after = ["lvm2-activation.service" "local-fs-pre.target"];
          before = ["sysroot.mount"];
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
        "/root/.cache/nix"
        "/var/lib/logrotate"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/var/lib/systemd/timers"
        "/var/lib/udisks2"
        "/var/log"
      ];
      files = ["/etc/machine-id"];
    };
    environment.etc = {
      "localtime".source = "/persist/system/etc/localtime";
    };

    services.logrotate.extraArgs = lib.mkAfter ["--state" "/var/lib/logrotate/logrotate.status"];

    system.activationScripts.bootstrapPersistHome.text = ''
      mkdir -p /persist/home/farlion
      chown farlion:users /persist/home/farlion
      chmod 0700 /persist/home/farlion
    '';

    programs.fuse.userAllowOther = true;
  };
}
