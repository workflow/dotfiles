{
  lib,
  isImpermanent,
  ...
}: {
  environment.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      "/var/lib/btrfs" # Scrub reports
    ];
  };

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = ["/"]; # Subvols of the same mount point don't need to be scrubbed
  };
}
