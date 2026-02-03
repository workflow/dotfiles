{...}: {
  flake.modules.nixos.btrfs = {config, lib, ...}:
    lib.mkIf config.dendrix.isBtrfs {
      environment.persistence."/persist/system" = lib.mkIf config.dendrix.isImpermanent {
        directories = [
          "/var/lib/btrfs" # Scrub reports
        ];
      };

      services.btrfs.autoScrub = {
        enable = true;
        interval = "monthly";
        fileSystems = ["/"]; # Subvols of the same mount point don't need to be scrubbed
      };
    };
}
