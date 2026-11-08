# General impermanence setup
# Note: specifics should live with their respective modules, where possible!
{...}: let
  # Not a writeShellApplication: the initrd only pulls in ELF deps, so runtimeInputs would be missing there.
  rootExplodeScript = builtins.readFile ./scripts/root-explode.sh;

  # Shared with the hibernate-resume check, so it exercises the real unit ordering
  mkRootExplodeService = {
    utils,
    device,
    script,
  }: let
    deviceUnit = "${utils.escapeSystemdPath device}.device";
  in {
    wantedBy = ["initrd-root-device.target"];
    requires = [deviceUnit];
    # Two independent layers keep a resume from hibernation safe, both ordering us after systemd-hibernate-resume.service,
    # which never returns on success: default dependencies (After=sysinit.target, which wants it) and local-fs-pre.target.
    # Dropping both makes checks.root-explode-hibernate-resume fail. See https://github.com/nix-community/impermanence/issues/250
    after = [deviceUnit "local-fs-pre.target"];
    before = ["sysroot.mount"];
    enableStrictShellChecks = true;
    environment.BTRFS_DEVICE = device;
    serviceConfig = {
      StandardOutput = "journal+console";
      StandardError = "journal+console";
      Type = "oneshot";
    };
    inherit script;
  };
in {
  flake.modules.homeManager.impermanence = {
    osConfig,
    lib,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".cache/nix"
        ".config/helm" # Helm repositories
        ".config/nix" # cachix repositories and such
        ".local/share/home-manager" # home-manager news read state
        ".local/share/nix" # Nix Repl History
        ".local/state/home-manager" # home-manager generations and GC roots
      ];
    };
  };

  flake.modules.nixos.impermanence = {
    config,
    lib,
    utils,
    ...
  }:
    lib.mkIf config.dendrix.isImpermanent {
      # Explode / on every cold boot, see https://grahamc.com/blog/erase-your-darlings/
      boot.initrd.systemd.services.root-explode = mkRootExplodeService {
        inherit utils;
        device = "/dev/mapper/nixos--vg-root";
        script = rootExplodeScript;
      };

      boot.tmp.cleanOnBoot = true;

      fileSystems."/persist".neededForBoot = true;

      environment.persistence."/persist/system" = {
        enable = true;
        hideMounts = true;
        directories = [
          "/root/.cache/nix"
          "/var/lib/logrotate" # See https://github.com/nix-community/impermanence/issues/270
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
          "/var/lib/systemd/timers"
          "/var/lib/udisks2"
          "/var/log"
        ];
        files = [
          "/etc/machine-id"
          # Host key for systemd encrypted credentials (systemd-creds); libvirt
          # seals its secrets-encryption-key with it, so it must survive reboots
          "/var/lib/systemd/credential.secret"
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
    };

  perSystem = {pkgs, ...}: {
    checks.root-explode = import ./_root-explode-test.nix {inherit pkgs rootExplodeScript;};
    checks.root-explode-hibernate-resume = import ./_hibernate-resume-test.nix {inherit pkgs mkRootExplodeService;};
  };
}
